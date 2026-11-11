#ifndef ARM_MPU_ARMV8_H
#define ARM_MPU_ARMV8_H

#ifdef __cplusplus
 extern "C" {
#endif

/* MPU 寄存器基地址偏移定义 */
#define MPU_Type_RBAR_A(n)      (0x04U + ((n) * 8U))
#define MPU_Type_RLAR_A(n)      (0x08U + ((n) * 8U))

__STATIC_INLINE void ARM_MPU_Enable(uint32_t MPU_Control) {
  __DSB();
  __ISB();
  MPU->CTRL = MPU_Control | MPU_CTRL_ENABLE_Msk;
}

__STATIC_INLINE void ARM_MPU_Disable(void) {
  __DSB();
  __ISB();
  MPU->CTRL &= ~MPU_CTRL_ENABLE_Msk;
}

__STATIC_INLINE void ARM_MPU_SetRegion(uint32_t rnr, uint32_t rbar, uint32_t rlar) {
  MPU->RNR = rnr;
  MPU->RBAR = rbar;
  MPU->RLAR = rlar;
}

#ifdef __cplusplus
}
#endif

#endif /* ARM_MPU_ARMV8_H */
