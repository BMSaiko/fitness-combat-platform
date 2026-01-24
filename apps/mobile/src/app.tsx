import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
// Importação correta para tipos com verbatimModuleSyntax
import type { User } from '../../../packages/shared/src/types';

const App: React.FC = () => {
  const user: User = {
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    userType: 'member',
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Fitness Combat Platform</Text>
      <Text style={styles.subtitle}>Mobile App</Text>
      <Text style={styles.userInfo}>User: {user.name}</Text>
      <Text style={styles.userInfo}>Email: {user.email}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 18,
    marginBottom: 16,
  },
  userInfo: {
    fontSize: 14,
    marginBottom: 4,
  },
});

export default App;