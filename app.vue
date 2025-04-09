<template>
  <NuxtLayout>
    <NuxtPage />
    <CustomToast />

  </NuxtLayout>
</template>

<style>
/* @font-face {
  font-family: 'Oswald';
  font-style: normal;
  font-weight: 200;
  font-display: swap;
  src: url('https://fonts.gstatic.com/s/oswald/v49/TK3_WkUHHAIjg75cFRf3bXL8LICs13FvsUZiYA.woff2') format('woff2');
} */
@import url('https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap');
/* @font-face {
  font-family: 'Oswald';
  font-style: normal;
  font-weight: 700;
  font-display: swap;
  src: url('https://fonts.gstatic.com/s/oswald/v49/TK3_WkUHHAIjg75cFRf3bXL8LICs1xZosUZiYA.woff2') format('woff2');
} */
.open-sans {
  font-family: "Open Sans", sans-serif;
  font-optical-sizing: auto;
  font-weight: 300;
  font-style: normal;
  font-variation-settings:
    "wdth" 100;
}


/* Optional: Preload fonts for better performance */
@media screen {
  @font-face {
    font-family: "Open Sans", sans-serif;
    font-style: normal;
    font-weight: 300 800;
    font-display: swap;
    src: url('https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap') ;
    unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
  }
}

/* You can add global styles here */
</style>
