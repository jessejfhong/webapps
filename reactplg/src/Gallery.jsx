// Describing UI


function Profile() {
    return (
        <img
            src="https://i.imgur.com/MK3eW3As.jpg"
            alt="Scrat"
        />
    );
}

function TodoList() {
    const scrat = {
        name: 'Scrat',
        theme: {
            backgroundColor: 'black',
            color: 'blue'
        }
    };

    return (
        <div style={scrat.theme}>
            <img
                src="https://i.imgur.com/MK3eW3As.jpg"
                alt={scrat.name}
            />

            <ol>
                <li>Get a job.</li>
                <li>Make some money.</li>
            </ol>
        </div>
    );
}


function Item({ person, isPacked = true }) { // destructed props with a default value
    return (
        <li>
            {person.name} {person.age} { isPacked && '✔'}
        </li>
    );
}


// syntax for nesting another component, the prop name must be children.
function Card({ children }) {
    return (
        <div id="gg">
            some random text
            {children}
        </div>
    );
}

function PackList() {
    return (
        <>
            <h1>My pack list.</h1>
            <ol>
                <Item person={{ name: 'Scrat', age: 10, weight: 23 }} />
                <Item person={{ name: 'Scratte', age: 20 }} isPacked={true} />
            </ol>
        </>
    );
}



export default function Gallery() {
    return (
        <section>
            <h2>Awesome scientists</h2>
            <Profile />
            <Profile />
            <Profile />

            <TodoList />

            <Card>
                <PackList />
            </Card>
        </section>
    );
}
