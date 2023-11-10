import './main.css';
import { Elm } from './Main.elm';

const app = Elm.Main.init({ flags: window.location.origin });

app.ports.requestSessionToken.subscribe((obj) => {
    const sesstionToken = "dummy session token";
    app.ports.sessionToken.send({
        data: obj,
        token: sesstionToken
    });
});
