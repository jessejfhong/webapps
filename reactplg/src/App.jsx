import { useState } from 'react';


function MyButton({ count, onClick}) {
    return(
        <button onClick={onClick}>
            { `You clicked me ${count} times!` }
        </button>
    );
}

export default function App() {
    const [count, setCount] = useState(0);

    function handleClick() {
        setCount(count + 1);
    }

    return (
        <>
            <h2 className="text-3xl font-blod underline">This is my React App</h2>
            <MyButton count={count} onClick={handleClick} />
            <MyButton count={count} onClick={handleClick} />
        </>
    );
}
