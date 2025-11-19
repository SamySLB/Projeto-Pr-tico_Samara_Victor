# Projeto Prático – Samara & Victor  
## **PokeApp**

Um aplicativo responsivo com layout feito para quem ama serviços de streamers e tem muita curiosidade sobre pokemons; Aqui você consegue ver o pokemon do mês, pop-ups com detalhes dos pokemons, e também personalizar seu perfil como quiser. Além disso, se estiver em duvida em como buscar seu pokemon favorito, sem problema, desde que saiba uma unica letra, você conseguirá pegar esse pokemon!

---

## 🚀 Tecnologias Utilizadas

- **Flutter 3+**
- **Dart**
- **PokéAPI v2**
- **Material 3**
- **FutureBuilder / Async Patterns**
- **Clean Code + princípios SOLID (simplificados)**

---

## 🔧 Melhorias Futuras

- Inclusão de **ícones personalizados**
- Funcionalidade de **favoritar Pokémons**
- **Navegação por categorias**

---

## 🧩 Princípios SOLID Utilizados

### **S – Single Responsibility**
Cada arquivo possui uma responsabilidade clara (models, serviços, UI).

### **O – Open/Closed**
Widgets reaproveitáveis e extensíveis, como `PokemonTile`.

### **L – Liskov Substitution**
Modelos e serviços fáceis de substituir em testes.

### **I – Interface Segregation**
Widgets pequenos, sem múltiplas obrigações.

### **D – Dependency Inversion**
A Home depende de um serviço abstraído (`ApiService`).

---

## 🌐 API Utilizada

Este projeto consome dados da **PokéAPI**, incluindo:

- Lista de Pokémons  
- Detalhes do Pokémon  
- Descrições  
- Imagens oficiais  
- Tipos  

---

