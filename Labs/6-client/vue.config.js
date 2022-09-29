module.exports = {
    devServer: {
      proxy: {
        '/': {
          target: 'https://abwg2mnp5ebrtt4gwebapp.azurewebsites.net',
          ws: true,
          changeOrigin: true
        }
      }
    }
  }