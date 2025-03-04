import express from 'express';
import multer from 'multer';
import { PrismaClient } from '@prisma/client';
import cors from 'cors';

const app = express();
const prisma = new PrismaClient();

app.use(cors());
app.use(express.json());

// Configuração do multer para armazenar o arquivo em memória
const upload = multer({ storage: multer.memoryStorage() });



/**
 * Rota para get de uma empresa
 */
/**
 * Rota para buscar uma empresa pelo CNPJ
 */
app.get('/empresa/get/:cnpj', async (req, res) => {
  const { cnpj } = req.params;

  console.log(`Recebida requisição para buscar empresa com CNPJ: ${cnpj}`); // Log 1

  try {
    const empresa = await prisma.empresa.findUnique({
      where: { CNPJ: cnpj },
    });

    console.log(`Resultado da busca no banco de dados: ${JSON.stringify(empresa)}`); // Log 2

    if (!empresa) {
      console.log(`Empresa com CNPJ ${cnpj} não encontrada`); // Log 3
      return res.status(404).json({ error: "Empresa não encontrada" });
    }

    res.status(200).json(empresa);
  } catch (error) {
    console.error(`Erro ao buscar empresa: ${error.message}`); // Log 4
    res.status(500).json({ error: "Erro ao buscar empresa" });
  }
});


/**
 * Rota para criar uma empresa
 */
app.post('/empresa', async (req, res) => {
  const { NomeFantasia, CNPJ, CEP, EstadoCidade, Bairro, RuaAvenida, Numero, Complemento, Responsavel, DataCriacao, Senha, IsAdm } = req.body;

  try {
    const empresa = await prisma.empresa.create({
      data: {
        NomeFantasia,
        CNPJ,
        CEP,
        EstadoCidade,
        Bairro,
        RuaAvenida,
        Numero,
        Complemento,
        Responsavel,
        DataCriacao: new Date(DataCriacao),
        Senha,
        IsAdm,
      },
    });

    res.status(201).json(empresa);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Erro ao criar empresa" });
  }
});




// Função para calcular saldo de horas
function calcularSaldoHoras(registros, cargaHoraria) {
  let totalHorasTrabalhadas = 0;

  registros.forEach(registro => {
      if (registro.Registro.entrada && registro.Registro.saida) {
          const entrada = new Date(registro.Registro.entrada);
          const saida = new Date(registro.Registro.saida);
          const horasTrabalhadas = (saida - entrada) / (1000 * 60 * 60); // Converter para horas
          totalHorasTrabalhadas += horasTrabalhadas;
      }
  });

  return totalHorasTrabalhadas - cargaHoraria;
}

app.get('/colaboradores/:cnpj/:matricula', async (req, res) => {
  const { cnpj, matricula } = req.params;

  try {
    const colaborador = await prisma.colaborador.findUnique({
      where: {
        CNPJ_Matricula: { // Usa a chave composta
          CNPJ: cnpj,
          Matricula: matricula,
        },
      },
    });

    if (!colaborador) {
      return res.status(404).json({ message: 'Colaborador não encontrado' });
    }

    // Converte a imagem (BLOB) para Base64, garantindo que seja um Buffer antes
    const colaboradorComImagem = {
      ...colaborador,
      imagem: colaborador.imagem ? Buffer.from(colaborador.imagem).toString('base64') : null,
    };

    res.status(200).json(colaboradorComImagem);
  } catch (error) {
    console.error('Erro ao buscar colaborador:', error);
    res.status(500).json({ message: 'Erro ao buscar colaborador' });
  }
});

/**
 * Rota para listar colaboradores
 */app.get('/colaboradores', async (req, res) => {
  try {
    // Busca todos os colaboradores com seus registros de ponto
    const colaboradores = await prisma.colaborador.findMany({
      include: {
        registroponto: true
      }
    });

    // Função para calcular o saldo de horas
    const calcularSaldoHoras = (registros, cargaHoraria) => {
      // Implemente a lógica para calcular o saldo de horas
      // Exemplo simples: soma das horas trabalhadas - carga horária
      let totalHorasTrabalhadas = 0;
      registros.forEach(registro => {
        totalHorasTrabalhadas += registro.horasTrabalhadas;
      });
      return totalHorasTrabalhadas - cargaHoraria;
    };

    // Adiciona o saldo de horas a cada colaborador
    const colaboradoresComSaldo = colaboradores.map(colab => {
      return {
        ...colab,
        saldoHoras: calcularSaldoHoras(colab.registroponto, colab.CargaHoraria)
      };
    });

    // Retorna os colaboradores com o saldo de horas calculado
    res.status(200).json(colaboradoresComSaldo);
  } catch (error) {
    console.error('Erro ao buscar colaboradores:', error);
    res.status(500).json({ message: 'Erro ao buscar colaboradores' });
  }
});


app.put('/colaboradores/:matricula/senha', async (req, res) => {
  const { matricula } = req.params; // Pega a matrícula da URL
  const {novaSenha } = req.body; // Obtém a senha atual e a nova senha do corpo da requisição


  try {
    // Verifica se o colaborador existe
    const colaborador = await prisma.colaborador.findUnique({
      where: { Matricula: matricula },
    });

    if (!colaborador) {
      return res.status(404).json({ error: 'Colaborador não encontrado!' });
    }

 

    // Atualiza a senha do colaborador
    await prisma.colaborador.update({
      where: { Matricula: matricula },
      data: { Senha: novaSenha },
    });

    res.status(200).json({ message: 'Senha atualizada com sucesso!' });
  } catch (error) {
    console.error('Erro ao atualizar senha:', error);
    res.status(500).json({ error: 'Erro ao atualizar senha', details: error.message });
  }
});




app.use(express.json());
app.post('/colaboradores', upload.single('imagem'), async (req, res) => {
  const {
    Matricula,
    Nome,
    CPF,
    RG,
    DataNascimento,
    DataAdmissao,
    NIS,
    CTPS,
    CargaHoraria,
    Cargo,
    CNPJ,
    Senha,
    IsAdm,
    login
  } = req.body;

  // Obtém o arquivo de imagem enviado
  const imagem = req.file ? req.file.buffer : null;

  try {
    const novoColaborador = await prisma.colaborador.create({
      data: {
        Matricula,
        Nome,
        CPF,
        RG,
        DataNascimento: new Date(DataNascimento),
        DataAdmissao: new Date(DataAdmissao),
        NIS,
        CTPS,
        CargaHoraria: parseInt(CargaHoraria),
        Cargo,
        CNPJ,
        imagem, // Salva o buffer da imagem como BLOB
        Senha,
        IsAdm: IsAdm === 'true',
        login
      }
    });

    res.status(201).json(novoColaborador);
  } catch (error) {
    console.error("Erro ao criar colaborador:", error);
    res.status(400).json({ error: "Erro ao criar colaborador", details: error.message });
  }
});
/**
 * Rota para registrar ponto
 */
app.post('/registroPonto', async (req, res) => {
  try {
    const { Dia, Matricula, Registro } = req.body;

    if (!Dia || !Matricula || !Registro) {
      return res.status(400).json({ message: 'Todos os campos são obrigatórios.' });
    }

    const registroPonto = await prisma.registroPonto.create({
      data: {
        Dia: new Date(Dia),
        Matricula,
        Registro,
      }
    });

    res.status(201).json(registroPonto);
  } catch (error) {
    console.error('Erro em registrar o ponto:', error);
    res.status(500).json({ message: 'Erro em registrar o ponto' });
  }
});

/**
 * Rota para atualizar um colaborador
 */app.put('/colaboradores/:matricula', upload.single('imagem'), async (req, res) => {
  const { matricula } = req.params; // Pega a matrícula da URL
  const {
    Nome,
    CPF,
    RG,
    DataNascimento,
    DataAdmissao,
    NIS,
    CTPS,
    CargaHoraria,
    Cargo,
    CNPJ,
    Senha,
    IsAdm,
    login
  } = req.body;

  // Obtém a imagem enviada
  const imagem = req.file ? req.file.buffer : null;

  try {
    const colaboradorAtualizado = await prisma.colaborador.update({
      where: { Matricula: matricula },
      data: {
        Nome,
        CPF,
        RG,
        DataNascimento: DataNascimento ? new Date(DataNascimento) : undefined,
        DataAdmissao: DataAdmissao ? new Date(DataAdmissao) : undefined,
        NIS,
        CTPS,
        CargaHoraria: CargaHoraria ? parseInt(CargaHoraria) : undefined,
        Cargo,
        CNPJ,
        imagem, // Atualiza a imagem se for enviada
        Senha,
        IsAdm: IsAdm === 'true',
        login
      }
    });

    res.status(200).json(colaboradorAtualizado);
  } catch (error) {
    console.error('Erro ao atualizar colaborador:', error);
    res.status(500).json({ error: 'Erro ao atualizar colaborador', details: error.message });
  }
});


/**
 * Rota para atualizar uma empresa
 */
app.put('/empresa/:CNPJ', async (req, res) => {
  try {
    const { NomeFantasia, CEP, EstadoCidade, Bairro, RuaAvenida, Numero, Complemento, Responsavel } = req.body;

    if (!NomeFantasia || !CEP || !EstadoCidade || !Bairro || !RuaAvenida || !Numero || !Responsavel) {
      return res.status(400).json({ message: 'Todos os campos são obrigatórios.' });
    }

    const empresa = await prisma.empresa.update({
      where: {
        CNPJ: req.params.CNPJ,
      },
      data: {
        NomeFantasia,
        CEP,
        EstadoCidade,
        Bairro,
        RuaAvenida,
        Numero,
        Complemento,
        Responsavel,
      }
    });

    res.status(200).json(empresa);
  } catch (error) {
    console.error('Erro ao atualizar a empresa:', error);
    res.status(500).json({ message: 'Erro ao atualizar empresa' });
  }
});

/**
 * Rota de login para empresa
 */
app.post('/empresa/login', async (req, res) => {

  const { cnpj, senha } = req.body;

  try {
    const empresa = await prisma.empresa.findUnique({ where: { CNPJ: cnpj } });

    if (!empresa) {
      return res.status(404).json({ success: false, message: "CNPJ não encontrado" });
    }

    if (empresa.Senha !== senha) {
      return res.status(401).json({ success: false, message: "Senha incorreta" });
    }

    res.status(200).json({ success: true, message: "Login efetuado com sucesso", isAdm: empresa.IsAdm });
  } catch (error) {
    console.error("Erro no servidor:", error);
    res.status(500).json({ success: false, message: "Erro no servidor" });
  }
});

/**
 * Rota de login para colaborador
 */
app.post('/colaborador/login', async (req, res) => {
  const { matricula, senha } = req.body;

  try {
    const colaborador = await prisma.colaborador.findUnique({ where: { Matricula: matricula } });

    if (!colaborador) {
      return res.status(404).json({ success: false, message: "Matrícula não encontrada" });
    }

    if (colaborador.Senha !== senha) {
      return res.status(401).json({ success: false, message: "Senha incorreta" });
    }

    res.status(200).json({ success: true, message: "Login efetuado com sucesso", isAdm: colaborador.IsAdm });
  } catch (error) {
    console.error("Erro no servidor:", error);
    res.status(500).json({ success: false, message: "Erro no servidor" });
  }
});

/**
 * Rota para deletar um colaborador
 */
app.delete('/colaboradores/:matricula', async (req, res) => {
  const { matricula } = req.params;

  try {
    // Verifica se o colaborador existe antes de deletar
    const colaborador = await prisma.colaborador.findUnique({
      where: { Matricula: matricula },
    });

    if (!colaborador) {
      return res.status(404).json({ message: 'Colaborador não encontrado!' });
    }

    await prisma.colaborador.delete({
      where: { Matricula: matricula },
    });

    res.status(200).json({ message: 'Colaborador deletado com sucesso!' });
  } catch (error) {
    console.error('Erro ao deletar colaborador:', error);
    res.status(500).json({ message: 'Erro ao deletar colaborador' });
  }
});

/**
 * Rota para deletar uma empresa
 */
app.delete('/empresa/:CNPJ', async (req, res) => {
  try {
    await prisma.empresa.delete({
      where: {
        CNPJ: req.params.CNPJ,
      }
    });

    res.status(200).json({ message: 'Empresa deletada com sucesso!' });
  } catch (error) {
    console.error('Erro ao deletar Empresa:', error);
    res.status(500).json({ message: 'Erro ao deletar Empresa' });
  }
});

/**
 * Rota para deletar um registro de ponto
 */
app.delete('/registroponto', async (req, res) => {
  try {
    const { matricula, dia } = req.query;

    if (!matricula || !dia) {
      return res.status(400).json({ message: 'Os parâmetros "matricula" e "dia" são obrigatórios.' });
    }

    await prisma.registroPonto.deleteMany({
      where: {
        Matricula: matricula,
        Dia: new Date(dia),
      },
    });

    res.status(200).json({ message: 'Registro deletado com sucesso!' });
  } catch (error) {
    console.error('Erro ao deletar registro:', error);
    res.status(500).json({ message: 'Erro ao deletar registro.' });
  }
});

// Inicia o servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
