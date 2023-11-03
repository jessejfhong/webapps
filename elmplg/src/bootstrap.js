import { Elm } from './Main.elm';

const app = Elm.Main.init({ flags: window.location.origin });

app.ports.requestSesssionToken.subscribe(async () => {
    const sessionToken = 'sessiontoken';
    app.ports.sessionTokenReceiver.send(sessionToken);
});
