import { useState, useRef } from 'react';

const btnStyle = 'bg-blue-600 hover:bg-blue-700 text-white font-blod px-4 py-2 rounded';
const btnStyleDisabled = 'px-4 py-2 text-white bg-blue-400 rounded focus:outline-none disabled:opacity-75';

const statuses = [
    'empty',
    'typing',
    'submitting',
    'success',
    'error'
];

export default function FormStateDemo() {
    return (
        <div>
            <h1>UI State</h1>
            <FormState />
        </div>
    );
}


function FormState() {

    const [answer, setAnswer] = useState('');
    const [error, setError] = useState(null);
    const [status, setStatus] = useState('typing');

    function submitForm(text) {
        return new Promise((resolve, reject) => {
            setTimeout(() => {
                let shouldError = text.toLowerCase() !== 'lima';
                if (shouldError) {
                    reject(new Error('Good guess but a wrong answer. Try again!'));
                } else {
                    resolve();
                }
            }, 1000);
        })
    }

    async function handleOnSubmit(e) {
        e.preventDefault();
        setStatus('submitting');
        try {
            await submitForm(answer);
            setStatus('success');
        } catch(err) {
            setStatus('typing');
            setError(err);
        }
    }

    function handleTextareaChange(e) {
        setAnswer(e.target.value);
    }

    if (status === 'success') {
        return (<p>That's right!</p>);
    }

    return (
        <div>
            <h2>City quiz</h2>
            <p>In which city is there a billboard that turns air into drinkable water?</p>
            <form onSubmit={handleOnSubmit}>
                <textarea
                    value={answer}
                    onChange={handleTextareaChange}
                    disabled={status === 'submitting'} />
                <br />
                <button
                    className={(status === 'submitting' || answer.length === 0) ? btnStyleDisabled : btnStyle}
                    disabled={status === 'submitting' || answer.length === 0}>
                    Submit
                </button>
                {error !== null &&
                    <p>
                        {error.message}        
                    </p>
                }
            </form>
        </div>
    );
}
