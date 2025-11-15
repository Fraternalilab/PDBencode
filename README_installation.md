openblas is keg-only, which means it was not symlinked into /opt/homebrew,
because macOS provides BLAS in Accelerate.framework.

For compilers to find openblas you may need to set:
  setenv LDFLAGS -L/opt/homebrew/opt/openblas/lib;
  setenv CPPFLAGS -I/opt/homebrew/opt/openblas/include;

For pkgconf to find openblas you may need to set:
  setenv PKG_CONFIG_PATH /opt/homebrew/opt/openblas/lib/pkgconfig;

For cmake to find openblas you may need to set:
  setenv CMAKE_PREFIX_PATH /opt/homebrew/opt/openblas;

