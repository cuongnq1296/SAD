c     Don't confuse, Emacs. This is -*- fortran -*- mode!
c$$$c     Math constant
c$$$      real*8 m_e, m_euler,
c$$$     $     m_log2e, m_log10e, m_ln2, m_ln10,
c$$$     $     m_pi, m_2pi, m_4pi, m_pi_2, m_pi_4,
c$$$     $     m_1_pi, m_2_pi, m_4_pi,
c$$$     $     m_sqrtpi, m_2_sqrtpi, m_sqrt2, m_1_sqrt2,
c$$$     $     m_sqrt3, m_1_sqrt3
c$$$
c$$$c     Napier's constant(Exp[1])
c$$$c     \lim_{n\rightarrow\infty}(1 + \frac{1}{n})^n
c$$$      parameter(m_e        = 2.7182818284590452354d0)
c$$$
c$$$c     Euler-Mascheroni constant(Euler's gamma)
c$$$c     \lim_{n\rightarrow\infty}(\sum_{k=1}^{n}\frac{1}{k} - \ln{n})
c$$$      parameter(m_euler    = 0.57721566490153286061d0)
c$$$
c$$$c     Log[2,  Exp[1]]
c$$$      parameter(m_log2e    = 1.4426950408889634074d0)
c$$$
c$$$c     Log[10, Exp[1]]
c$$$      parameter(m_log10e   = 0.43429448190325182765d0)
c$$$
c$$$c     Log[Exp[1],  2]
c$$$      parameter(m_ln2      = 0.69314718055994530942d0)
c$$$
c$$$c     Log[Exp[1], 10]
c$$$      parameter(m_ln10     = 2.30258509299404568402d0)
c$$$
c$$$c         Pi
c$$$      parameter(m_pi       = 3.14159265358979323846d0)
c$$$
c$$$c     2 * Pi
c$$$      parameter(m_2pi      = 6.28318530717958647693d0)
c$$$
c$$$c     4 * Pi
c$$$      parameter(m_4pi      = 12.5663706143591729539d0)
c$$$
c$$$c         Pi / 2
c$$$      parameter(m_pi_2     = 1.57079632679489661923d0)
c$$$
c$$$c         Pi / 4
c$$$      parameter(m_pi_4     = 0.78539816339744830962d0)
c$$$
c$$$c     1 / Pi
c$$$      parameter(m_1_pi     = 0.31830988618379067154d0)
c$$$
c$$$c     2 / Pi
c$$$      parameter(m_2_pi     = 0.63661977236758134308d0)
c$$$
c$$$c     4 / Pi
c$$$      parameter(m_4_pi     = 1.27323954473516268615d0)
c$$$
c$$$c         Sqrt[Pi]
c$$$      parameter(m_sqrtpi   = 1.77245385090551602730d0)
c$$$
c$$$c     2 / Sqrt[Pi]
c$$$      parameter(m_2_sqrtpi = 1.12837916709551257390d0)
c$$$
c$$$c     Sqrt[2]
c$$$      parameter(m_sqrt2    = 1.41421356237309504880d0)
c$$$
c$$$c     Sqrt[1/2]
c$$$      parameter(m_1_sqrt2  = 0.70710678118654752440d0)
c$$$
c$$$c     Sqrt[3]
c$$$      parameter(m_sqrt3    = 1.73205080756887729353d0)
c$$$
c$$$c     Sqrt[1/3]
c$$$      parameter(m_1_sqrt3  = 0.57735026918962576451d0)
c$$$
c$$$c     Standard alias for SAD sources
c$$$      real*8 napier, euler, pi, pi2, pi4, hpi, qpi
c$$$      parameter(napier = m_e, euler = m_euler)
c$$$      parameter(pi  = m_pi)
c$$$      parameter(pi2 = m_2pi,  pi4 = m_4pi)
c$$$      parameter(hpi = m_pi_2, qpi = m_pi_4)
c$$$
c$$$c     End of File
