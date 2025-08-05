// server.js
const express = require('express');
const mongoose = require('mongoose');
const multer = require('multer');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));
app.use((req, res, next) => {
  console.log("Richiesta Ricevuta")
  next()
})

// Crea cartella uploads se non esiste
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// Configurazione Multer per upload immagini
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Solo immagini sono permesse!'), false);
    }
  },
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB max
});

// Connessione MongoDB
mongoose.connect('mongodb+srv://itytano00:2ClwN7HyL8eJlRUm@testticket.3svruzb.mongodb.net/?retryWrites=true&w=majority&appName=TESTTICKET', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Schema Appunto
const appuntoSchema = new mongoose.Schema({
  nomeAutore: {
    type: String,
    required: true,
    trim: true
  },
  nomePersona: {
    type: String,
    required: true,
    trim: true
  },
  dipendenteResponsabile: {
    type: String,
    trim: true
  },
  contenuto: {
    type: String,
    required: true
  },
  immagini: [{
    filename: String,
    originalName: String,
    url: String
  }],
  dataCreazione: {
    type: Date,
    default: Date.now
  },
  dataModifica: {
    type: Date,
    default: Date.now
  },
  statoPratica: {
    type: String,
    default: 'Prendere in Carico'
  },
  tipologia: {
    type: String,
    required: true,

  },
  commenti: {
    type: [{ type: String }]
  }
});

const Appunto = mongoose.model('Appunto', appuntoSchema);

// ROUTES

// GET - Ottieni tutti gli appunti

app.get('/api/appunti', async (req, res) => {

  try {
    const appunti = await Appunto.find().sort({ dataModifica: -1 });
    res.json(appunti);
    console.log(appunti)
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET - Ottieni un appunto specifico
app.get('/api/appunti/:id', async (req, res) => {
  try {
    const appunto = await Appunto.findById(req.params.id);
    if (!appunto) {
      return res.status(404).json({ error: 'Appunto non trovato' });
    }
    res.json(appunto);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST - Crea nuovo appunto
app.post('/api/appunti', upload.array('immagini', 5), async (req, res) => {
  try {
    const { nomeAutore, nomePersona, contenuto, tipologia } = req.body;

    // Processa le immagini caricate
    const immagini = req.files ? req.files.map(file => ({
      filename: file.filename,
      originalName: file.originalname,
      url: `${req.protocol}://${req.get('host')}/uploads/${file.filename}`
    })) : [];

    const nuovoAppunto = new Appunto({
      nomeAutore,
      nomePersona,
      contenuto,
      tipologia,
      immagini
    });

    const appuntoSalvato = await nuovoAppunto.save();
    res.status(201).json(appuntoSalvato);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// PUT - Aggiorna appunto esistente
app.put('/api/appunti/:id', upload.array('nuoveImmagini', 5), async (req, res) => {
  try {
    const { nomeAutore, nomePersona, contenuto, immaginiDaRimuovere, statoPratica, dipendenteResponsabile } = req.body;

    const appunto = await Appunto.findById(req.params.id);
    if (!appunto) {
      return res.status(404).json({ error: 'Appunto non trovato' });
    }

    // // Rimuovi immagini se richiesto
    // if (immaginiDaRimuovere) {
    //   const daRimuovere = JSON.parse(immaginiDaRimuovere);
    //   daRimuovere.forEach(filename => {
    //     const filePath = path.join('uploads', filename);
    //     if (fs.existsSync(filePath)) {
    //       fs.unlinkSync(filePath);
    //     }
    //   });
    //   appunto.immagini = appunto.immagini.filter(img =>
    //     !daRimuovere.includes(img.filename)
    //   );
    // }

    // Aggiungi nuove immagini
    // if (req.files && req.files.length > 0) {
    //   const nuoveImmagini = req.files.map(file => ({
    //     filename: file.filename,
    //     originalName: file.originalname,
    //     url: `${req.protocol}://${req.get('host')}/uploads/${file.filename}`
    //   }));
    //   appunto.immagini.push(...nuoveImmagini);
    // }

    // Aggiorna i campi
    if (nomeAutore) appunto.nomeAutore = nomeAutore;
    if (nomePersona) appunto.nomePersona = nomePersona;
    if (contenuto) appunto.contenuto = contenuto;
    if (statoPratica) appunto.statoPratica = statoPratica;
    if (dipendenteResponsabile) appunto.dipendenteResponsabile = dipendenteResponsabile;
    appunto.dataModifica = new Date();

    const appuntoAggiornato = await appunto.save();
    res.json(appuntoAggiornato);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// DELETE - Elimina appunto
app.delete('/api/appunti/:id', async (req, res) => {
  try {
    const appunto = await Appunto.findById(req.params.id);
    if (!appunto) {
      return res.status(404).json({ error: 'Appunto non trovato' });
    }

    // Elimina le immagini associate
    appunto.immagini.forEach(img => {
      const filePath = path.join('uploads', img.filename);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    });

    await Appunto.findByIdAndDelete(req.params.id);
    res.json({ message: 'Appunto eliminato con successo' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET - Cerca appunti
app.put('/api/appunti/prendi-in-carico/:id', async (req, res) => {
  try {
    const { dipendenteResponsabile } = req.body;

    const appunto = await Appunto.findById(req.params.id);
    if (!appunto) {
      return res.status(404).json({ error: 'Appunto non trovato' });
    }

    appunto.dipendenteResponsabile = dipendenteResponsabile;
    appunto.statoPratica = 'In Lavorazione';
    appunto.dataModifica = new Date();

    const appuntoAggiornato = await appunto.save();
    res.json(appuntoAggiornato);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
})
app.get('/api/appunti/search/:query', async (req, res) => {
  try {
    const query = req.params.query;
    const appunti = await Appunto.find({
      $or: [
        { nomeAutore: { $regex: query, $options: 'i' } },
        { nomePersona: { $regex: query, $options: 'i' } },
        { contenuto: { $regex: query, $options: 'i' } }
      ]
    }).sort({ dataModifica: -1 });

    res.json(appunti);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
app.put('/api/commenti/aggiungiCommento', async (req, res) => {
  const { ticketId, commento } = req.body
  try {


    Appunto.findOneAndUpdate({ _id: ticketId },
      {
        $push: {
          commenti: commento
        }
      }
    )
  }
  catch (error) {

  }
})

// Error handling middleware
app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({ error: 'File troppo grande (max 5MB)' });
    }
  }
  res.status(500).json({ error: error.message });
});

// Avvia server
app.listen(3000, "0.0.0.0", () => {
  console.log(`Server in ascolto sulla porta ${PORT}`);
  console.log(`MongoDB connesso a: mongodb://localhost:27017/appunti_app`);
});

module.exports = app;
