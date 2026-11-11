/*!
    \file    startup_gd32e51x_hd.S
    \brief   start up file for GCC / EIDE

    \version 2026-02-09, V1.4.0, firmware for GD32E51x
*/

/*
 * Copyright (c) 2009-2018 Arm Limited. All rights reserved.
 * Copyright (c) 2024, GigaDevice Semiconductor Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

.syntax unified
.cpu cortex-m33
.thumb

/* Stack Configuration：真正使用的栈顶是 _estack（RAM 顶部，见向量表第 0 项）。
   下面这块 1KB 预留区仅作兼容保留，无人引用时会被 --gc-sections 自动回收。 */
.equ Stack_Size, 0x00000400
.section .stack, "aw", %nobits
.align 3
.global Stack_Mem
.global __initial_sp
Stack_Mem:
.space Stack_Size
__initial_sp:

/* Heap Configuration */
.equ Heap_Size, 0x00000400
.section .heap, "aw", %nobits
.align 3
.global __heap_base
.global __heap_limit
__heap_base:
Heap_Mem:
.space Heap_Size
__heap_limit:

/* Vector Table Mapped to Address 0 at Reset */
.section .isr_vector, "a"
.global __Vectors
.global __Vectors_End
.global __Vectors_Size

__Vectors:
.word _estack                           /* Top of Stack：RAM 顶部 0x20018000（gd32e513.ld 定义），远离堆 */
.word Reset_Handler                     /* Reset Handler */
.word NMI_Handler                       /* NMI Handler */
.word HardFault_Handler                 /* Hard Fault Handler */
.word MemManage_Handler                 /* MPU Fault Handler */
.word BusFault_Handler                  /* Bus Fault Handler */
.word UsageFault_Handler                /* Usage Fault Handler */
.word 0                                 /* Reserved */
.word 0                                 /* Reserved */
.word 0                                 /* Reserved */
.word 0                                 /* Reserved */
.word SVC_Handler                       /* SVCall Handler */
.word DebugMon_Handler                  /* Debug Monitor Handler */
.word 0                                 /* Reserved */
.word PendSV_Handler                    /* PendSV Handler */
.word SysTick_Handler                   /* SysTick Handler */

/* external interrupts handler */
.word WWDGT_IRQHandler                          /* 16:Window Watchdog Timer */
.word LVD_IRQHandler                            /* 17:LVD through EXTI Line detect */
.word TAMPER_IRQHandler                         /* 18:Tamper through EXTI Line detect */
.word RTC_IRQHandler                            /* 19:RTC through EXTI Line */
.word FMC_IRQHandler                            /* 20:FMC */
.word RCU_CTC_IRQHandler                        /* 21:RCU and CTC */
.word EXTI0_IRQHandler                          /* 22:EXTI Line 0 */
.word EXTI1_IRQHandler                          /* 23:EXTI Line 1 */
.word EXTI2_IRQHandler                          /* 24:EXTI Line 2 */
.word EXTI3_IRQHandler                          /* 25:EXTI Line 3 */
.word EXTI4_IRQHandler                          /* 26:EXTI Line 4 */
.word DMA0_Channel0_IRQHandler                  /* 27:DMA0 Channel0 */
.word DMA0_Channel1_IRQHandler                  /* 28:DMA0 Channel1 */
.word DMA0_Channel2_IRQHandler                  /* 29:DMA0 Channel2 */
.word DMA0_Channel3_IRQHandler                  /* 30:DMA0 Channel3 */
.word DMA0_Channel4_IRQHandler                  /* 31:DMA0 Channel4 */
.word DMA0_Channel5_IRQHandler                  /* 32:DMA0 Channel5 */
.word DMA0_Channel6_IRQHandler                  /* 33:DMA0 Channel6 */
.word ADC0_1_IRQHandler                         /* 34:ADC0 and ADC1 */
.word USBD_HP_CAN0_TX_IRQHandler                /* 35:USBD HP or CAN0 TX */
.word USBD_LP_CAN0_RX0_IRQHandler               /* 36:USBD LP or CAN0 RX0 */
.word CAN0_RX1_IRQHandler                       /* 37:CAN0 RX1 */
.word CAN0_EWMC_IRQHandler                      /* 38:CAN0 EWMC */
.word EXTI5_9_IRQHandler                        /* 39:EXTI5 to EXTI9 */
.word TIMER0_BRK_TIMER8_TIMER14_IRQHandler      /* 40:TIMER0 Break and TIMER8 */
.word TIMER0_UP_TIMER9_TIMER15_IRQHandler       /* 41:TIMER0 Update and TIMER9 */
.word TIMER0_TRG_CMT_TIMER10_TIMER16_IRQHandler /* 42:TIMER0 Trigger and Commutation and TIMER10 */
.word TIMER0_Channel_IRQHandler                 /* 43:TIMER0 Channel Capture Compare */
.word TIMER1_IRQHandler                         /* 44:TIMER1 */
.word TIMER2_IRQHandler                         /* 45:TIMER2 */
.word TIMER3_IRQHandler                         /* 46:TIMER3 */
.word I2C0_EV_IRQHandler                        /* 47:I2C0 Event */
.word I2C0_ER_IRQHandler                        /* 48:I2C0 Error */
.word I2C1_EV_IRQHandler                        /* 49:I2C1 Event */
.word I2C1_ER_IRQHandler                        /* 50:I2C1 Error */
.word SPI0_IRQHandler                           /* 51:SPI0 */
.word SPI1_I2S1ADD_IRQHandler                   /* 52:SPI1 or I2S1ADD */
.word USART0_IRQHandler                         /* 53:USART0 */
.word USART1_IRQHandler                         /* 54:USART1 */
.word USART2_IRQHandler                         /* 55:USART2 */
.word EXTI10_15_IRQHandler                      /* 56:EXTI10 to EXTI15 */
.word RTC_Alarm_IRQHandler                      /* 57:RTC Alarm */
.word USBD_WKUP_IRQHandler                      /* 58:USBD Wakeup */
.word TIMER7_BRK_TIMER11_IRQHandler             /* 59:TIMER7 Break and TIMER11 */
.word TIMER7_UP_TIMER12_IRQHandler              /* 60:TIMER7 Update and TIMER12 */
.word TIMER7_TRG_CMT_TIMER13_IRQHandler         /* 61:TIMER7 Trigger and Commutation and TIMER13 */
.word TIMER7_Channel_IRQHandler                 /* 62:TIMER7 Channel Capture Compare */
.word ADC2_IRQHandler                           /* 63:ADC2 */
.word EXMC_IRQHandler                           /* 64:EXMC */
.word SDIO_IRQHandler                           /* 65:SDIO */
.word TIMER4_IRQHandler                         /* 66:TIMER4 */
.word SPI2_I2S2ADD_IRQHandler                   /* 67:SPI2 or I2S2ADD */
.word UART3_IRQHandler                          /* 68:UART3 */
.word UART4_IRQHandler                          /* 69:UART4 */
.word TIMER5_DAC_IRQHandler                     /* 70:TIMER5 or DAC */
.word TIMER6_IRQHandler                         /* 71:TIMER6 */
.word DMA1_Channel0_IRQHandler                  /* 72:DMA1 Channel0 */
.word DMA1_Channel1_IRQHandler                  /* 73:DMA1 Channel1 */
.word DMA1_Channel2_IRQHandler                  /* 74:DMA1 Channel2 */
.word DMA1_Channel3_4_IRQHandler                /* 75:DMA1 Channel3 and Channel4 */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word CAN1_TX_IRQHandler                        /* 79:CAN1 TX */
.word CAN1_RX0_IRQHandler                       /* 80:CAN1 RX0 */
.word CAN1_RX1_IRQHandler                       /* 81:CAN1 RX1 */
.word CAN1_EWMC_IRQHandler                      /* 82:CAN1 EWMC */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word SHRTIMER_IRQ2_IRQHandler                  /* 85:SHRTIMER IRQ2 */
.word SHRTIMER_IRQ3_IRQHandler                  /* 86:SHRTIMER IRQ3 */
.word SHRTIMER_IRQ4_IRQHandler                  /* 87:SHRTIMER IRQ4 */
.word SHRTIMER_IRQ5_IRQHandler                  /* 88:SHRTIMER IRQ5 */
.word SHRTIMER_IRQ6_IRQHandler                  /* 89:SHRTIMER IRQ6 */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word SHRTIMER_IRQ0_IRQHandler                  /* 92:SHRTIMER IRQ0 */
.word SHRTIMER_IRQ1_IRQHandler                  /* 93:SHRTIMER IRQ1 */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word 0                                         /* Reserved */
.word I2C2_EV_IRQHandler                        /* 98:I2C2 Event */
.word I2C2_ER_IRQHandler                        /* 99:I2C2 Error */
.word USART5_IRQHandler                         /* 100:USART5 */
.word I2C2_WKUP_IRQHandler                      /* 101:I2C2 Wakeup */
.word USART5_WKUP_IRQHandler                    /* 102:USART5 Wakeup */
.word TMU_IRQHandler                            /* 103:TMU */

__Vectors_End:
.equ __Vectors_Size, __Vectors_End - __Vectors

.section .text
.align 2

/* Reset Handler */
.global Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    /* 将 .data 段的初值从 Flash(_sidata) 拷贝到 RAM(_sdata.._edata)
       否则 SystemCoreClock 等已初始化全局变量在 RAM 中是随机值 */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
1:
    cmp r1, r2
    bcs 2f
    ldr r3, [r0], #4
    str r3, [r1], #4
    b 1b
2:
    /* 将 .bss 段(_sbss.._ebss)清零，否则未初始化全局变量(如 delay)是随机值 */
    ldr r1, =_sbss
    ldr r2, =_ebss
    movs r3, #0
3:
    cmp r1, r2
    bcs 4f
    str r3, [r1], #4
    b 3b
4:
    ldr r0, =SystemInit
    blx r0
    /* 初始化 C 库(newlib)运行环境，printf/stdio 依赖它 */
    ldr r0, =__libc_init_array
    blx r0
    ldr r0, =main       /* GCC 环境下直接跳转到 main 函数，避开 Keil 的 __main */
    bx r0
.size Reset_Handler, .-Reset_Handler

/* dummy Exception Handlers */
.macro IRQ_HANDLER handler_name
.global \handler_name
.weak \handler_name
.type \handler_name, %function
\handler_name:
    b .
.size \handler_name, .-\handler_name
.endm

IRQ_HANDLER NMI_Handler
IRQ_HANDLER HardFault_Handler
IRQ_HANDLER MemManage_Handler
IRQ_HANDLER BusFault_Handler
IRQ_HANDLER UsageFault_Handler
IRQ_HANDLER SVC_Handler
IRQ_HANDLER DebugMon_Handler
IRQ_HANDLER PendSV_Handler
IRQ_HANDLER SysTick_Handler

/* Default Handler for External Interrupts */
.global Default_Handler
.type Default_Handler, %function
Default_Handler:
    b .
.size Default_Handler, .-Default_Handler

.macro DEFINE_WEAK_IRQ irq_name
.global \irq_name
.weak \irq_name
.set \irq_name, Default_Handler
.endm

DEFINE_WEAK_IRQ WWDGT_IRQHandler
DEFINE_WEAK_IRQ LVD_IRQHandler
DEFINE_WEAK_IRQ TAMPER_IRQHandler
DEFINE_WEAK_IRQ RTC_IRQHandler
DEFINE_WEAK_IRQ FMC_IRQHandler
DEFINE_WEAK_IRQ RCU_CTC_IRQHandler
DEFINE_WEAK_IRQ EXTI0_IRQHandler
DEFINE_WEAK_IRQ EXTI1_IRQHandler
DEFINE_WEAK_IRQ EXTI2_IRQHandler
DEFINE_WEAK_IRQ EXTI3_IRQHandler
DEFINE_WEAK_IRQ EXTI4_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel0_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel1_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel2_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel3_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel4_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel5_IRQHandler
DEFINE_WEAK_IRQ DMA0_Channel6_IRQHandler
DEFINE_WEAK_IRQ ADC0_1_IRQHandler
DEFINE_WEAK_IRQ USBD_HP_CAN0_TX_IRQHandler
DEFINE_WEAK_IRQ USBD_LP_CAN0_RX0_IRQHandler
DEFINE_WEAK_IRQ CAN0_RX1_IRQHandler
DEFINE_WEAK_IRQ CAN0_EWMC_IRQHandler
DEFINE_WEAK_IRQ EXTI5_9_IRQHandler
DEFINE_WEAK_IRQ TIMER0_BRK_TIMER8_TIMER14_IRQHandler
DEFINE_WEAK_IRQ TIMER0_UP_TIMER9_TIMER15_IRQHandler
DEFINE_WEAK_IRQ TIMER0_TRG_CMT_TIMER10_TIMER16_IRQHandler
DEFINE_WEAK_IRQ TIMER0_Channel_IRQHandler
DEFINE_WEAK_IRQ TIMER1_IRQHandler
DEFINE_WEAK_IRQ TIMER2_IRQHandler
DEFINE_WEAK_IRQ TIMER3_IRQHandler
DEFINE_WEAK_IRQ I2C0_EV_IRQHandler
DEFINE_WEAK_IRQ I2C0_ER_IRQHandler
DEFINE_WEAK_IRQ I2C1_EV_IRQHandler
DEFINE_WEAK_IRQ I2C1_ER_IRQHandler
DEFINE_WEAK_IRQ SPI0_IRQHandler
DEFINE_WEAK_IRQ SPI1_I2S1ADD_IRQHandler
DEFINE_WEAK_IRQ USART0_IRQHandler
DEFINE_WEAK_IRQ USART1_IRQHandler
DEFINE_WEAK_IRQ USART2_IRQHandler
DEFINE_WEAK_IRQ EXTI10_15_IRQHandler
DEFINE_WEAK_IRQ RTC_Alarm_IRQHandler
DEFINE_WEAK_IRQ USBD_WKUP_IRQHandler
DEFINE_WEAK_IRQ TIMER7_BRK_TIMER11_IRQHandler
DEFINE_WEAK_IRQ TIMER7_UP_TIMER12_IRQHandler
DEFINE_WEAK_IRQ TIMER7_TRG_CMT_TIMER13_IRQHandler
DEFINE_WEAK_IRQ TIMER7_Channel_IRQHandler
DEFINE_WEAK_IRQ ADC2_IRQHandler
DEFINE_WEAK_IRQ EXMC_IRQHandler
DEFINE_WEAK_IRQ SDIO_IRQHandler
DEFINE_WEAK_IRQ TIMER4_IRQHandler
DEFINE_WEAK_IRQ SPI2_I2S2ADD_IRQHandler
DEFINE_WEAK_IRQ UART3_IRQHandler
DEFINE_WEAK_IRQ UART4_IRQHandler
DEFINE_WEAK_IRQ TIMER5_DAC_IRQHandler
DEFINE_WEAK_IRQ TIMER6_IRQHandler
DEFINE_WEAK_IRQ DMA1_Channel0_IRQHandler
DEFINE_WEAK_IRQ DMA1_Channel1_IRQHandler
DEFINE_WEAK_IRQ DMA1_Channel2_IRQHandler
DEFINE_WEAK_IRQ DMA1_Channel3_4_IRQHandler
DEFINE_WEAK_IRQ CAN1_TX_IRQHandler
DEFINE_WEAK_IRQ CAN1_RX0_IRQHandler
DEFINE_WEAK_IRQ CAN1_RX1_IRQHandler
DEFINE_WEAK_IRQ CAN1_EWMC_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ2_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ3_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ4_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ5_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ6_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ0_IRQHandler
DEFINE_WEAK_IRQ SHRTIMER_IRQ1_IRQHandler
DEFINE_WEAK_IRQ I2C2_EV_IRQHandler
DEFINE_WEAK_IRQ I2C2_ER_IRQHandler
DEFINE_WEAK_IRQ USART5_IRQHandler
DEFINE_WEAK_IRQ I2C2_WKUP_IRQHandler
DEFINE_WEAK_IRQ USART5_WKUP_IRQHandler
DEFINE_WEAK_IRQ TMU_IRQHandler
.end