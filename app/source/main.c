/*!
    \file    main.c
    \brief   running led

    \version 2026-02-09, V1.4.0, firmware for GD32E51x
*/

/*
    Copyright (c) 2025, GigaDevice Semiconductor Inc.

    Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this 
       list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice, 
       this list of conditions and the following disclaimer in the documentation 
       and/or other materials provided with the distribution.
    3. Neither the name of the copyright holder nor the names of its contributors 
       may be used to endorse or promote products derived from this software without 
       specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
OF SUCH DAMAGE.
*/

#include "gd32e51x.h"
#include <stdio.h>
#include "systick.h"
#include "FreeRTOS.h"
#include "task.h"

/*!
    \brief      initialize UART5 (USART5) as the debug print port
                GD32E513VCT6: USART5_TX = PA12, USART5_RX = PA11 (AFIO remap)
    \param[in]  none
    \param[out] none
    \retval     none
*/
static void uart5_init(void)
{
    /* enable GPIOA / AFIO / USART5 clock (USART5 is on APB2) */
    rcu_periph_clock_enable(RCU_GPIOA);
    rcu_periph_clock_enable(RCU_AF);
    rcu_periph_clock_enable(RCU_USART5);

    /* mux PA11/PA12 to USART5 */
    gpio_afio_port_config(AFIO_PA12_USART5_CFG, ENABLE);   /* PA12 -> USART5_RX */
    gpio_afio_port_config(AFIO_PA11_USART5_CFG, ENABLE);   /* PA11 -> USART5_TX */

    /* connect port to USART5: TX = AF-PP, RX = floating input */
    gpio_init(GPIOA, GPIO_MODE_AF_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_11);
    gpio_init(GPIOA, GPIO_MODE_IN_FLOATING, GPIO_OSPEED_50MHZ, GPIO_PIN_12);

    /* USART5 configure: 115200 8N1, polling mode (no interrupt needed) */
    usart_deinit(USART5);
    usart_baudrate_set(USART5, 115200U);
    usart_word_length_set(USART5, USART_WL_8BIT);
    usart_stop_bit_set(USART5, USART_STB_1BIT);
    usart_parity_config(USART5, USART_PM_NONE);
    usart_hardware_flow_rts_config(USART5, USART_RTS_DISABLE);
    usart_hardware_flow_cts_config(USART5, USART_CTS_DISABLE);
    usart_receive_config(USART5, USART_RECEIVE_ENABLE);
    usart_transmit_config(USART5, USART_TRANSMIT_ENABLE);
    usart_enable(USART5);
}

void print_task(void *pvParameters)
{
    (void)pvParameters;

    for (;;)
    {
        printf("i am print task\r\n");
        //printf("watermark: %u words\r\n", uxTaskGetStackHighWaterMark(NULL));
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

void led_task(void *pvParameters)
{
    (void)pvParameters;

    for (;;)
    {
       printf("i am led task\r\n");
       //printf("watermark: %u words\r\n", uxTaskGetStackHighWaterMark(NULL));
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

void print_freertos_version(void)
{
    // 方法一：打印完整版本字符串（推荐）
    printf("FreeRTOS Kernel Version: %s\r\n", tskKERNEL_VERSION_NUMBER);
}

/*!
    \brief      main function
    \param[in]  none
    \param[out] none
    \retval     none
*/
int main(void)
{
#ifdef __FIRMWARE_VERSION_DEFINE
    uint32_t fw_ver = 0U;
#endif /* __FIRMWARE_VERSION_DEFINE */
    /* configure systick */
    //systick_config();
    /* initialize debug UART: UART5 (USART5) TX=PA12 RX=PA11 @115200-8N1 */
    uart5_init();
    printf("\r\n=== GD32E513VCT6 dock, UART5 ready ===\r\n");
    printf("SystemCoreClock: %u Hz\r\n", (unsigned int)SystemCoreClock);
    /* enable the LED clock */
    rcu_periph_clock_enable(RCU_GPIOG);
    /* configure LED GPIO port */ 
    gpio_init(GPIOG, GPIO_MODE_OUT_PP, GPIO_OSPEED_MAX, GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12 | GPIO_PIN_13);

    gpio_bit_reset(GPIOG, GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12 | GPIO_PIN_13);

#ifdef __FIRMWARE_VERSION_DEFINE
    fw_ver = gd32e51x_firmware_version_get();
    /* print firmware version */
    printf("\r\nGD32E51X series firmware version: V%d.%d.%d\r\n", (uint8_t)(fw_ver >> 24), (uint8_t)(fw_ver >> 16), (uint8_t)(fw_ver >> 8));
#endif /* __FIRMWARE_VERSION_DEFINE */
    print_freertos_version();
    
    xTaskCreate(led_task, "led", 256, NULL, 2, NULL);       /* 256字=1KB：printf链峰值~550B，余量约一倍；与 configMINIMAL_STACK_SIZE 同档 */
    xTaskCreate(print_task, "log", 256, NULL, 1, NULL);
    vTaskStartScheduler(); /* 之后 main 永不返回，MSP 只剩中断在用 */
    while (1)
        ;

#if 0
    while(1){
        /* turn on LED1, turn off LED4 */
        gpio_bit_set(GPIOG, GPIO_PIN_10);
        gpio_bit_reset(GPIOG, GPIO_PIN_13);
        delay_1ms(100U);

        /* turn on LED2, turn off LED1 */
        gpio_bit_set(GPIOG, GPIO_PIN_11);
        gpio_bit_reset(GPIOG, GPIO_PIN_10);
        delay_1ms(100U);

        /* turn on LED3, turn off LED2 */
        gpio_bit_set(GPIOG, GPIO_PIN_12);
        gpio_bit_reset(GPIOG, GPIO_PIN_11);
        delay_1ms(100U);

        /* turn on LED4, turn off LED3 */
        gpio_bit_set(GPIOG, GPIO_PIN_13);
        gpio_bit_reset(GPIOG, GPIO_PIN_12);
        delay_1ms(100U);
    }
#endif
}

#ifdef GD_ECLIPSE_GCC
/* retarget the C library printf function to UART5, in Eclipse GCC environment */
int __io_putchar(int ch)
{
    usart_data_transmit(USART5, (uint8_t) ch );
    while(RESET == usart_flag_get(USART5, USART_FLAG_TBE));
    return ch;
}
#else
/* retarget the C library printf function to UART5 */
int fputc(int ch, FILE *f)
{
    usart_data_transmit(USART5, (uint8_t)ch);
    while(RESET == usart_flag_get(USART5, USART_FLAG_TBE));

    return ch;
}
#endif /* GD_ECLIPSE_GCC */


#include <sys/stat.h>

/* 手动实现标准 C 库所需的底层桩函数，消除链接警告 */
int _close(int file) { return -1; }
int _fstat(int file, struct stat *st) { st->st_mode = S_IFCHR; return 0; }
int _isatty(int file) { return 1; }
int _lseek(int file, int ptr, int dir) { return 0; }
int _read(int file, char *ptr, int len) { return 0; }

/* newlib 的 printf/puts 最终走 _write（本工程为 GCC + newlib-nano），逐字节发到 UART5 */
int _write(int file, char *ptr, int len)
{
    for (int i = 0; i < len; i++) {
        usart_data_transmit(USART5, (uint8_t)ptr[i]);
        while(RESET == usart_flag_get(USART5, USART5_FLAG_TBE));
    }
    return len;
}

