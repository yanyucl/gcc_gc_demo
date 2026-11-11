#ifndef __CMSIS_GCC_H
#define __CMSIS_GCC_H

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wsign-conversion"
#pragma GCC diagnostic ignored "-Wconversion"
#pragma GCC diagnostic ignored "-Wunused-parameter"

/* 核心指令定义，让 GCC 能够识别单片机底部的特殊汇编 */
__attribute__((always_inline)) __STATIC_INLINE void __enable_irq(void) {
  __asm volatile ("cpsie i" : : : "memory");
}

__attribute__((always_inline)) __STATIC_INLINE void __disable_irq(void) {
  __asm volatile ("cpsid i" : : : "memory");
}

__attribute__((always_inline)) __STATIC_INLINE uint32_t __get_CONTROL(void) {
  uint32_t result;
  __asm volatile ("MRS %0, control" : "=r" (result) );
  return(result);
}

__attribute__((always_inline)) __STATIC_INLINE void __set_CONTROL(uint32_t control) {
  __asm volatile ("MSR control, %0" : : "r" (control) : "memory");
}

__attribute__((always_inline)) __STATIC_INLINE uint32_t __get_IPSR(void) {
  uint32_t result;
  __asm volatile ("MRS %0, ipsr" : "=r" (result) );
  return(result);
}

__attribute__((always_inline)) __STATIC_INLINE uint32_t __get_APSR(void) {
  uint32_t result;
  __asm volatile ("MRS %0, apsr" : "=r" (result) );
  return(result);
}

__attribute__((always_inline)) __STATIC_INLINE uint32_t __get_xPSR(void) {
  uint32_t result;
  __asm volatile ("MRS %0, xpsr" : "=r" (result) );
  return(result);
}

__attribute__((always_inline)) __STATIC_INLINE uint32_t __get_PSP(void) {
  uint32_t result;
  __asm volatile ("MRS %0, psp" : "=r" (result) );
  return(result);
}

__attribute__((always_inline)) __STATIC_INLINE void __set_PSP(uint32_t topOfProcStack) {
  __asm volatile ("MSR psp, %0" : : "r" (topOfProcStack) : "memory");
}

__attribute__((always_inline)) __STATIC_INLINE uint32_t __get_MSP(void) {
  uint32_t result;
  __asm volatile ("MRS %0, msp" : "=r" (result) );
  return(result);
}

__attribute__((always_inline)) __STATIC_INLINE void __set_MSP(uint32_t topOfMainStack) {
  __asm volatile ("MSR msp, %0" : : "r" (topOfMainStack) : "memory");
}

#define __NOP()                             __asm volatile ("nop")
#define __WFI()                             __asm volatile ("wfi")
#define __WFE()                             __asm volatile ("wfe")
#define __SEV()                             __asm volatile ("sev")
#define __ISB()                             __asm volatile ("isb\n" : : : "memory")
#define __DSB()                             __asm volatile ("dsb\n" : : : "memory")
#define __DMB()                             __asm volatile ("dmb\n" : : : "memory")

#pragma GCC diagnostic pop

#endif /* __CMSIS_GCC_H */
