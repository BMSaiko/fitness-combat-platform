// Simple test component without React Native for now
import React from 'react';

const App: React.FC = () => {
  return React.createElement('div', null, 
    React.createElement('h1', null, 'Fitness Combat Platform Mobile App'),
    React.createElement('p', null, 'Coming Soon...')
  );
};

export default App;