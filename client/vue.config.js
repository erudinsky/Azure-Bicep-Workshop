module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'https://abwheomgyk2kukrqkv.vault.azure.net/',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }