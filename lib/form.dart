import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghcc/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class FormWhatsapp extends StatefulWidget {
  const FormWhatsapp({super.key});

  @override
  State<FormWhatsapp> createState() => _FormWhatsappState();
}

class _FormWhatsappState extends State<FormWhatsapp> {

  final TextEditingController _custTitle = TextEditingController();
  final TextEditingController _custNohp = TextEditingController();
  final TextEditingController _custName = TextEditingController();
  final TextEditingController _tarikh = TextEditingController(text: '');
  final TextEditingController _masa = TextEditingController(text: '');
  final TextEditingController _fulltext = TextEditingController();

  final TextEditingController _jenisRepair = TextEditingController();
  final TextEditingController _kosRepair = TextEditingController();
  final TextEditingController _sparePart = TextEditingController();
  final TextEditingController _hargaDepo = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _custName.dispose();
    _custNohp.dispose();
    _tarikh.dispose();
    _masa.dispose();
    _fulltext.dispose();
    _custTitle.dispose();

    _jenisRepair.dispose();
    _kosRepair.dispose();
    _sparePart.dispose();
    _hargaDepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * .1),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 30),

          FormCustomer(controller: _custTitle, hint: 'Gelaran Pesakit', index: 1),
          FormCustomer(controller: _custName, hint: 'Nama Pesakit', index: 1),
          FormCustomer(controller: _custNohp, hint: 'No Tel Pesakit', index: 2),
          FormCustomer(controller: _tarikh, hint: 'Tarikh', index: 3),
          FormCustomer(controller: _masa, hint: 'Masa', index: 4),

          _selectedValue == "Deposit Repair Hearing Aid" ? FormCustomer(controller: _jenisRepair, hint: 'Jenis Repair', index: 5) : const SizedBox(),
          _selectedValue == "Deposit Repair Hearing Aid" ? FormCustomer(controller: _sparePart, hint: 'Spare Part Diganti', index: 5) : const SizedBox(),
          _selectedValue == "Deposit Repair Hearing Aid" ? FormCustomer(controller: _kosRepair, hint: 'Kos Repair', index: 5) : const SizedBox(),
          _selectedValue == "Deposit Repair Hearing Aid" ? FormCustomer(controller: _hargaDepo, hint: 'Deposit', index: 5) : const SizedBox(),

          _pilihan(),
          const SizedBox(height: 30),

          _area(),

          const SizedBox(height: 30),
          _button(),

          const SizedBox(height: 150),

        ],
      ),
    );
  }


  String? _selectedValue;
  List<String> items = [
    "Homevisit",
    "Collect Hearing Aid",
    "Fitting Hearing Aid",
    "Deposit Repair Hearing Aid",
    "Impression Taking",
    "Appointment Follow up Hospital",
  ];

  Widget _pilihan(){
    return DropdownButton<String>(
      value: _selectedValue,
      focusColor: Colors.grey[100],
      hint: const Text('Pilihan'),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue;
        });
        _compute(_selectedValue ?? "");
      },
    );
  }

  Widget _area(){
    return TextField(
      controller: _fulltext,
        maxLines: null,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        )
    );
  }

  Widget _button(){
    return Row(
      children: [
        MaterialButton(
          color: Colors.green,
            onPressed: (){
              launchWhatsApp(phone: _custNohp.text, message: _fulltext.text);
            },
          child: const Text("Submit", style: TextStyle(
            color: Colors.white
          )),
        ),

        const SizedBox(width: 30),

        MaterialButton(
          color: Colors.blue,
          onPressed: (){
            // copy text dulu
            Clipboard.setData(ClipboardData(text: _fulltext.text)).then((_){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                onVisible: (){
                  // HapticFeedback.vibrate().timeout(const Duration(milliseconds: 1500));
                  // HapticFeedback.heavyImpact();
                },
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                //backgroundColor: const Color(0xfffcf2f2),
                content: const Text("Sudah disalin", style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5, color: Colors.white,
                  //fontWeight: FontWeight.bold
                )),
              ));

              // then parse to ws url
              launchWhatsApp(phone: _custNohp.text, message: "");
            });

          },
          child: const Text("Copy Text", style: TextStyle(
              color: Colors.white
          )),
        )
      ],
    );
  }

  void launchWhatsApp({required String phone, required String message}) async {
    String url() {
      return "https://wa.me/6$phone/?text=$message";
    }

    if (await canLaunchUrl(Uri.parse(url()))) {
      await launchUrl(Uri.parse(url()));
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void _compute(String text){

    if(text == "Impression Taking"){
      _fulltext.text = "Selamat pagi ${_custTitle.text}.\n\n"
          "Kami dari Global Hearing Care Centre Segamat, syarikat pembekal alat bantu pendengaran. Kami ingin maklumkan permohonan alat bantu pendengaran ${_custTitle.text} *${_custName.text.toUpperCase()}* telah mendapat kelulusan PEKA B40.\n"
          "Jadi kami ingin buat temujanji untuk mengambil acuan telinga pesakit di centre kami.\n\nBerikut adalah maklumat temujanji:\n\n"
          "*Tarikh: ${_tarikh.text}*\n"
          "*Masa: ${_masa.text.toUpperCase()}*\n"
          "*Alamat:* ${Constant().alamat}\n\n"

          "Jika ada sebarang pertanyaan atau tidak dapat hadir temujanji, sila hubungi kami di talian ${Constant().hpoffice} / ${Constant().hpmobile}.\n\nTerima Kasih.";
    }

    else if(text == "Collect Hearing Aid"){
      _fulltext.text = "Hi selamat pagi ${_custTitle.text}.\n\nKami dari Global hearing Care Centre Segamat.\nKami ingin maklumkan alat repair ${_custTitle.text} *${_custName.text.toUpperCase()}* sudah siap repair.\nJadi kami mahu buat appointment untuk ${_custTitle.text} *${_custName.text.toUpperCase()}* di centre kami.\n\n"
          "Berikut adalah maklumat temujanji berkenaan:\n\n"
          "*Tarikh: ${_tarikh.text}*\n"
          "*Masa: ${_masa.text.toUpperCase()}*\n"
          "Tempat: ${Constant().alamat}\n\n"
          "Sebarang pertanyaan boleh hubungi kami di talian ${Constant().hpoffice} / ${Constant().hpmobile}\n\nTerima Kasih.";
    }

    else if(text == "Fitting Hearing Aid"){
      _fulltext.text = "Assalamualaikum dan selamat petang ${_custTitle.text},\n\nKami dari Global Hearing Care Centre Segamat, pusat alat pendengaran.\n\nKami ingin maklumkan alat pendengaran ${_custTitle.text} *${_custName.text.toUpperCase()}* sudah siap. Jadi kami ingin membuat temujanji pemakaian alat pendengaran di centre."
          "\n\nBerikut adalah butiran temujanji berkenaan:\n\n"
          "*Tarikh: ${_tarikh.text}*\n"
          "*Masa: ${_masa.text.toUpperCase()}*\n"
          "Tempat: ${Constant().alamat}\n\n"
          "Jika ${_custTitle.text} tidak dapat hadir pada tarikh berkenaan, sila maklumkan kepada kami untuk dapatkan tarikh yang baru.\n\nTerima kasih.";
    }

    else if(text == "Appointment Follow up Hospital"){
      _fulltext.text = "Selamat pagi ${_custTitle.text}.\n\nKami dari Global Hearing Care Centre Segamat, pusat alat bantu dengar. Kami ingin maklumkan bahawa pihak Hospital Segamat minta kami untuk berikan tarikh appointment follow up alat pendengaran ${_custTitle.text} *${_custName.text.toUpperCase()}* di Hospital Segamat.\n\n"
          "Berikut merupakan maklumat temujanji:\n\n"
          "*Tarikh: ${_tarikh.text}*\n"
          "*Masa: ${_masa.text.toUpperCase()}*\n"
          "Tempat: Hospital Segamat (Unit Audiologi)"
          "\n\nKami ingin minta jasa baik ${_custTitle.text} untuk menulis tarikh, masa appointment, dan Unit AUDIO di dalam buku appointment hospital.\n"
          "Sila bawa alat pendengaran dan aksesori yang diterima semasa appointment.\n\nTerima kasih";
    }

    else if(text == "Deposit Repair Hearing Aid"){
      _fulltext.text = "Assalamualaikum dan selamat petang ${_custTitle.text},\n\n"
          "Kami dari Global Hearing Care Centre Segamat, syarikat pembekal alat bantu pendengaran.\n"
          "Kami telah mendapat maklumat dari kilang berkaitan alat bantu dengar ${_custTitle.text} ${_custName.text}. Kami mendapati bahawa alat tersebut telah tamat warranty. "
          "\n\nBerikut adalah maklumat kerosakan dan kos repair:\n\n"

          "*Jenis repair: ${_jenisRepair.text}*\n"
          "*Spare part diganti: ${_sparePart.text}*\n"
          "*Kos repair: RM ${_kosRepair.text}*\n\n"

          "Jika ${_custTitle.text} setuju untuk repair alat, ${_custTitle.text} boleh buat bayaran deposit sebanyak RM ${_hargaDepo.text}. "
          "Pembayaran boleh dibuat kepada kami secara tunai, online transfer atau ATM transfer ke akaun kami:\n\n"

          "${Constant().bankacc}"
          "\n\nSila hantar bukti pembayaran kepada kami di whatsapp atau secara terus ke centre kami di alamat:\n${Constant().alamat}\n\n"
          "Sekiranya ${_custTitle.text} mempunyai pertanyaan lanjut, boleh terus hubungi kami di talian ${Constant().hpoffice} / ${Constant().hpmobile}.\n\nTerima kasih.";
    }

  }

}

class FormCustomer extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int index;
  const FormCustomer({super.key, required this.controller, required this.hint, required this.index});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(
            index == 1 ? Icons.person :
            index == 2 ? Icons.smartphone :
            index == 3 ? Icons.calendar_month :
            index == 4 ? Icons.timelapse : Icons.settings),
        labelText: hint,
      ),
      onSaved: (String? value) {

      },
    );
  }
}


