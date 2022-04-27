module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'https://abw.azurewebsites.net',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }