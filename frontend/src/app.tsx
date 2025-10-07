import React from 'react';
import { createRoot } from 'react-dom/client';
import { Simpress } from './simpress';

class Test extends React.Component {
    public render() {
        return (
            <div>{Simpress.say()}</div>
        );
    }
}

const container = document.getElementById('root')!;
const root = createRoot(container);
root.render(
    <React.StrictMode>
        <Test />
    </React.StrictMode>
);
