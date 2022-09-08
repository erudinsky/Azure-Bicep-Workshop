module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'https://abwheomgyk2kukrqwebapp.azurewebsites.net/',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }