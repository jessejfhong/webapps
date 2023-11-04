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
