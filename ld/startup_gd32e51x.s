  .syntax unified
  .cpu cortex-m33
  .fpu fpv5-sp-d16
  .thumb

.global g_pfnVectors
.global Reset_Handler
.weak   Default_Handler

/* 定义中断向量表的核心段 */
  .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word _estack            /* 栈顶指针，由链接脚本提供 */
  .word Reset_Handler      /* 复位中断，芯片上电的第一个入口 */
  .word NMI_Handler
  .word HardFault_Handler
  .word MemManage_Handler
  .word BusFault_Handler
  .word UsageFault_Handler
  .word 0
  .word 0
  .word 0
  .word 0
  .word SVC_Handler
  .word DebugMon_Handler
  .word 0
  .word PendSV_Handler
  .word SysTick_Handler

  /* 提示：此处为了让编译闭环，只列出了 Cortex-M33 的核心中断。 */
  /* 如果你的 C 代码里用到了串口、定时器等硬件外设中断，请在下方继续按顺序追加对应的外设向量名。 */

  .section .text.Reset_Handler,"ax",%progbits
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   sp, =_estack      /* 强制将堆栈指针指向栈顶 */

/* 将数据段从 FLASH 复制到 RAM */
  movs  r1, #0
  b     LoopCopyDataInit

CopyDataInit:
  ldr   r3, =_sidata
  ldr   r3, [r3, r1]
  str   r3, [r2, r1]
  adds  r1, r1, #4

LoopCopyDataInit:
  ldr   r0, =_sdata
  ldr   r2, =_edata
  add   r3, r0, r1
  cmp   r3, r2
  bcc   CopyDataInit

/* 将 BSS 段在 RAM 中清零 */
  ldr   r2, =_sbss
  ldr   r4, =_ebss
  movs  r3, #0
  b     LoopFillZeroBss

FillZeroBss:
  str   r3, [r2]
  adds  r2, r2, #4

LoopFillZeroBss:
  cmp   r2, r4
  bcc   FillZeroBss

/* 调用硬件系统初始化（由系统的 system_gd32e51x.c 提供） */
  bl    SystemInit
/* 终于跳入主函数 */
  bl    main

LoopForever:
  b     LoopForever
  .size Reset_Handler, .-Reset_Handler

/* 默认的空特殊中断处理 */
  .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b     Infinite_Loop
  .size Default_Handler, .-Default_Handler

/* 弱定义基础内核中断，方便用户在 C 文件中直接覆写重写这些中断 */
  .weak NMI_Handler
  .thumb_set NMI_Handler,Default_Handler
  .weak HardFault_Handler
  .thumb_set HardFault_Handler,Default_Handler
  .weak MemManage_Handler
  .thumb_set MemManage_Handler,Default_Handler
  .weak BusFault_Handler
  .thumb_set BusFault_Handler,Default_Handler
  .weak UsageFault_Handler
  .thumb_set UsageFault_Handler,Default_Handler
  .weak SVC_Handler
  .thumb_set SVC_Handler,Default_Handler
  .weak DebugMon_Handler
  .thumb_set DebugMon_Handler,Default_Handler
  .weak PendSV_Handler
  .thumb_set PendSV_Handler,Default_Handler
  .weak SysTick_Handler
  .thumb_set SysTick_Handler,Default_Handler
