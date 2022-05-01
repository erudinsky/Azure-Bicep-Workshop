module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'https://localhost:5000',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }