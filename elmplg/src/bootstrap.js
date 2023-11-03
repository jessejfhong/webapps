import './main.css';
import { Elm } from './Main.elm';

const app = Elm.Main.init({ flags: window.location.origin });

app.ports.requestSesssionToken.subscribe(async () => {
    const sessionToken = 'sessiontoken';
    app.ports.sessionTokenReceiver.send(sessionToken);
});

app.ports.jsonValue.send({
    id: 1,
    name: 'Jesse',
    gender: true
});

app.ports.jsonValue.send({
    id: 1,
    name: 'iPhone',
    price: 1555.6,
    quantity: 2
});
