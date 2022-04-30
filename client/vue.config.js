module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'https://abwvewyoj5t7eslkwebapp.azurewebsites.net',
          // target: 'https://localhost:5000',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }