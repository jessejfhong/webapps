import './main.css';

import React from 'react';
import ReactDOM from 'react-dom/client';

import App from './App.jsx';
import TicTacToe from './TicTacToe.jsx';
import Gallery from './Gallery.jsx';
import Interactivity from './Interactivity.jsx';
import { DraggableDemo } from './Draggable.jsx';
import FormStateDemo from './FormState.jsx';

ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
        {/*<App />*/}

        {/*<Gallery />*/}

        {/*<TicTacToe />*/}

        {/*<Interactivity />*/}

        {/*<DraggableDemo />*/}

        <FormStateDemo />

    </React.StrictMode>,
);
