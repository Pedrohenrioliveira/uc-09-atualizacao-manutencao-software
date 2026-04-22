// app.js - Patas Felizes Pet Shop

document.addEventListener('DOMContentLoaded', function () {
  const formContato = document.getElementById('formContato');

  if (formContato) {
    formContato.addEventListener('submit', async function (e) {
      e.preventDefault();

      const nomeInput = document.getElementById('nome');
      const emailInput = document.getElementById('email');
      const mensagemInput = document.getElementById('mensagem');

      const nome = nomeInput ? nomeInput.value.trim() : '';
      const email = emailInput ? emailInput.value.trim() : '';
      const mensagem = mensagemInput ? mensagemInput.value.trim() : '';

      if (!nome || !email || !mensagem) {
        alert('Por favor, preencha todos os campos!');
        return;
      }

      const emailValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      if (!emailValido.test(email)) {
        alert('Por favor, digite um e-mail válido!');
        return;
      }

      const dados = {
        nome,
        email,
        mensagem
      };

      try {
        const response = await fetch('http://localhost:5118/api/contatos', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(dados)
        });

        const resultado = await response.json();

        if (!response.ok) {
          alert(resultado.mensagem || 'Erro ao enviar contato.');
          return;
        }

        alert(resultado.mensagem || 'Mensagem enviada com sucesso!');
        formContato.reset();
      } catch (error) {
        console.error('Erro ao enviar contato:', error);
        alert('Não foi possível conectar com a API.');
      }
    });
  }

  const formAgendamento = document.getElementById('formAgendamento');

  if (formAgendamento) {
    formAgendamento.addEventListener('submit', async function (e) {
      e.preventDefault();

      const nomeTutorInput = document.getElementById('nomeTutor');
      const nomePetInput = document.getElementById('nomePet');
      const servicoInput = document.getElementById('servico');
      const dataInput = document.getElementById('data');
      const telefoneInput = document.getElementById('telefone');

      const nomeTutor = nomeTutorInput ? nomeTutorInput.value.trim() : '';
      const nomePet = nomePetInput ? nomePetInput.value.trim() : '';
      const servico = servicoInput ? servicoInput.value.trim() : '';
      const dataAgendamento = dataInput ? dataInput.value : '';
      const telefone = telefoneInput ? telefoneInput.value.trim() : '';

      if (!nomeTutor || !nomePet || !servico || !dataAgendamento || !telefone) {
        alert('Por favor, preencha todos os campos do agendamento!');
        return;
      }

      const dados = {
        nomeTutor,
        nomePet,
        servico,
        dataAgendamento,
        telefone
      };

      try {
        const response = await fetch('http://localhost:5118/api/agendamentos', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(dados)
        });

        const resultado = await response.json();

        if (!response.ok) {
          alert(resultado.mensagem || 'Erro ao realizar agendamento.');
          return;
        }

        alert(resultado.mensagem || 'Agendamento realizado com sucesso!');
        formAgendamento.reset();
      } catch (error) {
        console.error('Erro ao enviar agendamento:', error);
        alert('Não foi possível conectar com a API.');
      }
    });
  }

  const sections = document.querySelectorAll('section[id]');
  const navLinks = document.querySelectorAll('nav a');
  const header = document.querySelector('header');

  window.addEventListener('scroll', function () {
    let current = '';
    const headerHeight = header ? header.offsetHeight : 60;
    const scrollPosition = window.scrollY + headerHeight + 10;

    sections.forEach(section => {
      if (
        scrollPosition >= section.offsetTop &&
        scrollPosition < section.offsetTop + section.offsetHeight
      ) {
        current = section.getAttribute('id');
      }
    });

    navLinks.forEach(link => {
      link.classList.remove('active');

      if (link.getAttribute('href') === '#' + current) {
        link.classList.add('active');
      }
    });
  });

  const anoAtual = new Date().getFullYear();
  const anoElemento = document.getElementById('ano');

  if (anoElemento) {
    anoElemento.textContent = anoAtual;
  }
});