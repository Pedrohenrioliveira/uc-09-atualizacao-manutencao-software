// app.js - Patas Felizes Pet Shop

document.addEventListener('DOMContentLoaded', function () {
  const API_BASE_URL = 'http://127.0.0.1:5118';

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
        const response = await fetch(`${API_BASE_URL}/api/contatos`, {
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
        const response = await fetch(`${API_BASE_URL}/api/agendamentos`, {
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

  async function carregarDepoimentos() {
    const listaDepoimentos = document.getElementById('listaDepoimentos');

    if (!listaDepoimentos) {
      return;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/api/depoimentos`);
      const depoimentos = await response.json();

      if (!response.ok) {
        listaDepoimentos.innerHTML = `
          <div class="bg-yellow-50 rounded-2xl p-6 shadow col-span-full text-center text-red-500">
            Não foi possível carregar os depoimentos.
          </div>
        `;
        return;
      }

      if (!depoimentos || depoimentos.length === 0) {
        listaDepoimentos.innerHTML = `
          <div class="bg-yellow-50 rounded-2xl p-6 shadow col-span-full text-center text-gray-500">
            Ainda não há depoimentos cadastrados.
          </div>
        `;
        return;
      }

      listaDepoimentos.innerHTML = '';

      depoimentos.forEach(depoimento => {
        const card = document.createElement('div');
        card.className = 'bg-yellow-50 rounded-2xl p-6 shadow';

        const imagemUrl = `${API_BASE_URL}/${depoimento.caminhoFoto}`;

        card.innerHTML = `
          <img
            src="${imagemUrl}"
            alt="Foto de ${depoimento.nomeCliente}"
            class="w-14 h-14 rounded-full mb-4 object-cover"
          />
          <p class="text-gray-700 italic mb-4">"${depoimento.texto}"</p>
          <span class="font-bold text-yellow-600">${depoimento.nomeCliente}</span>
        `;

        listaDepoimentos.appendChild(card);
      });
    } catch (error) {
      console.error('Erro ao carregar depoimentos:', error);
      listaDepoimentos.innerHTML = `
        <div class="bg-yellow-50 rounded-2xl p-6 shadow col-span-full text-center text-red-500">
          Erro ao conectar com a API de depoimentos.
        </div>
      `;
    }
  }

  carregarDepoimentos();

  async function carregarFotos() {
    const listaFotos = document.getElementById('listaFotos');

    if (!listaFotos) {
      return;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/api/fotos`);
      const fotos = await response.json();

      if (!response.ok) {
        listaFotos.innerHTML = `
          <div class="col-span-full text-center text-red-500">
            Não foi possível carregar a galeria.
          </div>
        `;
        return;
      }

      if (!fotos || fotos.length === 0) {
        listaFotos.innerHTML = `
          <div class="col-span-full text-center text-gray-500">
            A galeria ainda está vazia.
          </div>
        `;
        return;
      }

      listaFotos.innerHTML = '';

      fotos.forEach(foto => {
        const card = document.createElement('div');
        card.className = 'bg-yellow-50 rounded-2xl shadow overflow-hidden';

        const imagemAntesUrl = `${API_BASE_URL}/${foto.caminhoFotoAntes}`;
        const imagemDepoisUrl = `${API_BASE_URL}/${foto.caminhoFotoDepois}`;

        card.innerHTML = `
          <div class="flex">
            <div class="w-1/2 relative">
              <span class="absolute top-2 left-2 bg-gray-800 text-white text-xs font-bold px-2 py-1 rounded opacity-80">Antes</span>
              <img src="${imagemAntesUrl}" alt="Foto Antes - ${foto.nomeCachorro}" class="w-full h-48 md:h-60 object-cover border-r border-yellow-200"/>
            </div>
            <div class="w-1/2 relative">
              <span class="absolute top-2 right-2 bg-yellow-500 text-white text-xs font-bold px-2 py-1 rounded opacity-90">Depois</span>
              <img src="${imagemDepoisUrl}" alt="Foto Depois - ${foto.nomeCachorro}" class="w-full h-48 md:h-60 object-cover"/>
            </div>
          </div>
          <div class="p-4 text-center">
            <p class="font-bold text-yellow-600">${foto.nomeCachorro}</p>
            <p class="text-sm text-gray-500">Patas Felizes</p>
          </div>
        `;

        listaFotos.appendChild(card);
      });
    } catch (error) {
      console.error('Erro ao carregar fotos:', error);
      listaFotos.innerHTML = `
        <div class="col-span-full text-center text-red-500">
          Erro ao conectar com a API de fotos.
        </div>
      `;
    }
  }

  carregarFotos();

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