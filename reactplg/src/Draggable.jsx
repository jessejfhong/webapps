import { useState, useRef } from 'react';

export default function Draggable({ children }) {
    const ref = useRef();
    const [position, setPosition] = useState({ x: 0, y: 0 });

    function handleOnDragEnd(e) {
        setPosition({
            x: e.clientX - (ref.current.offsetWidth / 2),
            y: e.clientY - (ref.current.offsetHeight / 2)
        });
    }

    return (
        <div
            draggable="true"
            style={{
                position: 'absolute',
                transform: `translate(${position.x}px, ${position.y}px)`
            }}
            onDragEnd={handleOnDragEnd}
            ref={ref}>
            {children}
        </div>
    );
}


function Dot() {
    return (
        <div style={{
            width: 100,
            height: 100,
            backgroundColor: 'Chocolate',
            borderRadius: '50%'
        }}>
        </div>
  );
}


export function DraggableDemo() {
    return (
        <div style={{
            with: '100vw',
            height: '100vh',
            backgroundColor: "gray"
        }}>
            <Draggable>
                <Dot />
            </Draggable>
        </div>
    );
}
