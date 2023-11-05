import './main.css';
import { Elm } from './Main.elm';

const app = Elm.Main.init({ flags: window.location.origin });

app.ports.requestJsonValue.subscribe(async (flag) => {
    if (flag === 1) {
        app.ports.jsonValue.send({
            id: 1,
            name: 'Jesse',
            gender: true
        });
    } else {
        app.ports.jsonValue.send({
            id: 1,
            name: 'iPhone',
            price: 1555.6,
            quantity: 2
        });
    }
});

app.ports.stringValue.send('Hi there!');

if (navigator.storage && navigator.storage.persist) {
    navigator.storage.persist().then((persistent) => {
        if (persistent) {
            console.log("Storage will not be cleared except by explicit user action");
        } else {
            console.log("Storage may be cleared by the UA under storage pressure.");
        }
    });
}
