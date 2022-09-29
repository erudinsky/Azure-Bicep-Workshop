import BootstrapVue from 'bootstrap-vue';
// import SuiVue from 'semantic-ui-vue';
import Vue from 'vue';
import App from './App.vue';
import router from './router';
import 'bootstrap/dist/css/bootstrap.css';
// import 'semantic-ui-css/semantic.min.css';

Vue.use(BootstrapVue);
// Vue.use(SuiVue);

Vue.config.productionTip = false;

new Vue({
  router,
  render: (h) => h(App),
}).$mount('#app');
