// app.js - Patas Felizes Pet Shop
// Desenvolvido por: João Dev (estagiário)
// Data: 15/03/2024

// =====================
// VALIDAÇÃO DO FORMULÁRIO
// =====================

document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('formContato');

  if (form) {
    form.addEventListener('submit', function (e) {
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

      alert('Mensagem enviada com sucesso! Entraremos em contato em até 24 horas.');
      form.reset();
    });
  }

  // =====================
  // HIGHLIGHT DO MENU ATIVO
  // =====================

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

  // =====================
  // ANO NO FOOTER (DINÂMICO)
  // =====================

  const anoAtual = new Date().getFullYear();
  const anoElemento = document.getElementById('ano');

  if (anoElemento) {
    anoElemento.textContent = anoAtual;
  }
});