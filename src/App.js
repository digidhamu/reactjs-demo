import React from 'react';
import logo from './logo.svg';
import './App.css';
import Button from '@material-ui/core/Button';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>
          DaaS Demo - React App
        </h1>
        <Button variant="contained" color="primary">
          Home
        </Button>
        <p>
          Version v1.1.0-alpha.4
        </p>
      </header>
    </div>
  );
}

export default App;
