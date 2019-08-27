import { NativeModules } from 'react-native'
const { GPay } = NativeModules;

export default class GPayProxy {
    static ENVIRONMENT_TEST = 2;
    static ENVIRONMENT_PRODUCTION = GPay.ENVIRONMENT_PRODUCTION;
    
    get test_env () {
        return GPayProxy.ENVIRONMENT_TEST;
    }

    get prod_env () {
        return GPayProxy.ENVIRONMENT_PRODUCTION;
    }

    checkGPayIsEnable(env, networks) {
        return GPay.checkGPayIsEnable(env, networks);
    }

    show(env, req) {
        return new Promise(function(res, err) {
            GPay.show(env, req).then(paymentResponse => {
                res(JSON.parse(paymentResponse));
            })
        });
    }
}
