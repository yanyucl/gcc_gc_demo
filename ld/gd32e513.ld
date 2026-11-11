/*
 * GD32E513 GCC Linker Script
 * 适用芯片型号: GD32E513 (Cortex-M33 内核)
 * 硬件资源配置: Flash 256KB / SRAM 96KB
 */

/* 1. 声明程序入口点（对应启动文件中的 Reset_Handler） */
ENTRY(Reset_Handler)

/* 2. 定义堆栈的最小保留空间 */
_Min_Heap_Size  = 0x400;  /* 保留 1024 字节堆空间 (对应启动文件 Heap_Size) */
_Min_Stack_Size = 0x400;  /* 保留 1024 字节栈空间 (对应启动文件 Stack_Size) */

/* 3. 定义堆栈顶地址（指向 RAM 最高地址处） */
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* 4. 定义物理内存映射区间 (GD32E513 标准边界) */
MEMORY
{
  ROM (rx)      : ORIGIN = 0x08000000, LENGTH = 256K  /* 内置 Flash */
  RAM (xrw)     : ORIGIN = 0x20000000, LENGTH = 96K  /* 内置 SRAM */
}

/* 5. 定义具体的内存段布局 */
SECTIONS
{
  /* 中断向量表段：必须放在 Flash 的最开头(0x08000000) */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* 保持不被编译器优化清除 */
    . = ALIGN(4);
  } >ROM

  /* 代码及只读数据段 */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* 用户的核心代码 */
    *(.text*)          /* 其余相关代码 */
    *(.rodata)         /* 只读常量数据 (如 const char*) */
    *(.rodata*)
    *(.glue_7)         /* arm 到 thumb 代码交织缓冲（GCC 兼容） */
    *(.glue_7t)
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* 记录代码段的结束位置 */
  } >ROM

  /* ARM 异常处理和展开段 */
  .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >ROM
  .ARM        : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } >ROM

  /* C/C++ 构造/析构函数数组（__libc_init_array 遍历执行，缺了会被静默丢弃） */
  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >ROM

  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >ROM

  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >ROM

  /* 初始化数据加载地址（由 Flash 复制到 RAM 的初始值标记） */
  _sidata = LOADADDR(.data);

  /* 已初始化的全局/静态变量段 (存储在 RAM 中，其初值从 ROM 拷贝) */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* 数据段在 RAM 中的起始位置 */
    *(.data)
    *(.data*)

    . = ALIGN(4);
    _edata = .;        /* 数据段在 RAM 中的结束位置 */
  } >RAM AT> ROM

  /* 未初始化的全局/静态变量段 (进入 main 前将被清零) */
  .bss :
  {
    . = ALIGN(4);
    _sbss = .;         /* BSS 段在 RAM 中的起始位置 */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* BSS 段在 RAM 中的结束位置 */
    __bss_end__ = _ebss;
  } >RAM

  /* 用户堆栈安全边界检查段 */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM

  /* 注意：不要在这里 /DISCARD/ libgcc.a / libm.a —— 按库名匹配会把将来需要的
     浮点运算例程一并丢掉，届时出现"符号在库里却报 undefined reference"的怪错。
     链接器本来只拉取被引用的库成员，无需手动丢弃。 */
}
