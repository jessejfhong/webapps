import { useState } from 'react';

const btnStyle = 'bg-blue-500 hover:bg-blue-700 text-white font-blod py-2 px-4 rounded';

export default function Interactivity() {
    return (
        <>
            <ToolBar />
        </>
    );
}

function ToolBar() {
    return (
        <div>
            <MyButton1 />
            <MyButton2 message="Hello Jesse">Jesse</MyButton2>
            <PlayButton message="Oblivion" />
            <UploadButton />
            <MyEventDemo />

            <SignUp />

            <hr />
            <HookDemo />
        </div>
    );
}


// Event handler name typical start with handle, fowllowed by event name,
// which usually defined inside the component
function MyButton1() {

    function handleClick() {
        console.log('Button clicked.');
    }

    return (
        <button onClick={handleClick} className={btnStyle}>
            Click Me
        </button>
    );
}


// Event handle can capture value from props
function MyButton2({ message, children }) {
    function handleClick() {
        console.log(message);
    }

    return (
        <button onClick={handleClick} className={btnStyle}>
            {children}
        </button>
    );
}


// Pass down event handler via props, PlayButton and UploadButton both
// uses MyButton3, but each of them define handler that do different
// things, but reuse MyButton3
function MyButton3({ onClick, children }) {
    return (
        <button onClick={onClick} className={btnStyle}>
            {children}
        </button>
    );
}

function PlayButton({ message }) {
    function handleClick() {
        console.log(message);
    }

    return (
        <MyButton3 onClick={handleClick}>
            Play {message}
        </MyButton3>
    );
}

function UploadButton() {
    function handleClick() {
        console.log('Uploading');
    }

    return (
        <MyButton3 onClick={handleClick}>
            Upload
        </MyButton3>
    );
}


// Event propagation, event propagate upwards, from child to parent
// All events propagate in React except onScroll

// when click Play, the console print play, then div clicked.
// when click Upload, the console print upload, then div clicked.
// when click on the div, the console print div clicked only.
function MyEventDemo() {

    // event fisrt travel downwards from parent to child during capture phase
    // this handle get called event though the child call stopPropagation()
    // to stop the event from propagate upwords from child to parent.
    // however, the use of this event is rare.
    function handleOnClickCapture() {
        console.log('onClick captured');
    }

    return (
        <div onClick={() => console.log('div clicked')}
            onClickCapture={handleOnClickCapture}>
            <MyButton3 onClick={() => console.log('play')}>
                Play
            </MyButton3>
            <MyButton3 onClick={() => console.log('upload')}>
                Upload
            </MyButton3>
            <MyButton4 onSmash={() => console.log('stop')}>
                Stop
            </MyButton4>
        </div>
    );
}

// event propagation can be stopped
function MyButton4({ onSmash, children }) {
    function handleClick(e) {
        e.stopPropagation();
        onSmash();
    }

    return (
        <button onClick={handleClick} className={btnStyle}>
            {children}
        </button>
    );
}


// Prevent default behaviour
function SignUp() {
    function handleOnSubmit(e) {
        e.preventDefault();
        console.log('submit form');
    }

    return (
        <form onSubmit={handleOnSubmit}>
            <input />
            <button className={btnStyle} onClick={() => console.log('submit clicked')}>
                Submit
            </button>
        </form>
    );
}



// Hook Demo
function HookDemo() {
    return (
        <div>
            <UseStateHook />
        </div>
    );
}

function UseStateHook() {
    const [count, setCount] = useState(0);

    function handleClick() {
        setCount(count + 1);
    }

    return (
        <div>
            <button className={btnStyle} onClick={handleClick}>
                Count
            </button>
            <span>{count}</span>
        </div>
    );
}
