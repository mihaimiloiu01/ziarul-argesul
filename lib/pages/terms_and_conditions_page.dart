import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Termeni și Condiții"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          _termsAndConditionsText,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

const String _termsAndConditionsText = '''

  Utilizând aplicatia de stiri Ziarul Argesul, sunteți de acord cu următoarii termeni și condiții:

  1. Utilizare: Puteți utiliza această aplicație în scopuri personale și non-comerciale. Nu utilizați această aplicație în scopuri ilegale.

  2. Conținut: Conținutul afișat în această aplicație are scop informativ. Informatiile prezentate respecta toate normele jurnalistice impuse publicatiilor de pe teritoriul Romaniei.

  3. Drepturi de autor: Intreg continutul acestei aplicatii, inclusiv articolele, imaginile și logo-urile, sunt protejate de drepturi de autor. Nu puteți reproduce, distribui sau modifica informatiile aprobarea personalului din conducerea Ziarului Argesul.

  4. Confidențialitate: Aplicatia nu colecteaza si nu stocheaza datele personale ale utilizatorului.

  5. Actualizări: Putem actualiza acești termeni și condiții de la un moment la altul. Este responsabilitatea dumneavoastra, a consumatorului,. să revizuiți și să respectați cea mai recentă versiune.

  Utilizând aplicația de știri, recunoașteți că ați citit și ați fost de acord cu acești termeni și condiții.

  Dacă aveți întrebări sau nelămuriri, vă rugăm să ne contactați la numarul de telefon 0737035999 sau folosind functionaliatea de apelare implementata in aplicatie. De asemenea, ne puteti contacta si accesand site-ul nostru.
''';
