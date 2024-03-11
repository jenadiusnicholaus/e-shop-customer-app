import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';

class CustomTheme {
  static MaterialColor generateMaterialColorFromColor(Color color) {
    return MaterialColor(color.value, {
      50: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
      100: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
      200: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
      300: Color.fromRGBO(color.red, color.green, color.blue, 0.4),
      400: Color.fromRGBO(color.red, color.green, color.blue, 0.5),
      500: Color.fromRGBO(color.red, color.green, color.blue, 0.6),
      600: Color.fromRGBO(color.red, color.green, color.blue, 0.7),
      700: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
      800: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1.0),
    });
  }

  // static final defaultPinTheme = PinTheme(
  //   width: 50,
  //   height: 50,
  //   textStyle: TextStyle(
  //       fontSize: 20,
  //       color: Color.fromARGB(255, 40, 81, 117),
  //       fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     border: Border.all(color: Color.fromARGB(255, 109, 165, 211)),
  //     borderRadius: BorderRadius.circular(20),
  //   ),
  // );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: generateMaterialColorFromColor(
          Color.fromARGB(255, 238, 152, 152).withOpacity(.7)),
      // colorScheme: generateMaterialColorFromColor(Colors.red),
      // primarySwatch: generateMaterialColorFromColor(
      //     Color.fromARGB(255, 255, 255, 255).withOpacity(.7)),
      appBarTheme: const AppBarTheme(
          // backgroundColor: Theme.of(context).primaryColor
          // backgroundColor: primary,
          ),
      useMaterial3: true,

      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 159, 155, 155),
      ),

      textTheme: TextTheme(
        bodyText1: GoogleFonts.montserrat(
          fontSize: 12,
          color: Colors.black,
        ),
        bodyText2: GoogleFonts.montserrat(
          fontSize: 14,
          color: Colors.black,
        ),
        headline3: GoogleFonts.montserrat(
          fontSize: 24,
          color: Colors.black,
        ),
        headline4: GoogleFonts.montserrat(
            fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
        headline5: GoogleFonts.montserrat(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
        headline6: GoogleFonts.montserrat(
          fontSize: 30,
          color: Colors.black,
        ),
        caption: GoogleFonts.montserrat(
          fontSize: 12,
          color: const Color.fromARGB(255, 85, 74, 74),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: generateMaterialColorFromColor(Colors.teal),
      // primaryColor: MaterialStateColor.resolveWith(
      //     (states) => Color.fromARGB(255, 27, 36, 45)),
      primarySwatch: generateMaterialColorFromColor(Colors.teal.shade900),

      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 159, 155, 155),
      ),
      // primarySwatch: generateMaterialColorFromColor(BodaColors.primaryColor),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromARGB(255, 27, 36, 45),
      ),
      dividerTheme: DividerThemeData(color: Color.fromARGB(255, 55, 50, 50)),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(color: Colors.teal.shade900),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3,
            // color: generateMaterialColorFromColor(BodaColors.primaryColor),
          ),
        ),
      ),
      cardColor: const Color.fromARGB(255, 30, 40, 50),
      appBarTheme: const AppBarTheme(color: const Color(0xFF253341)),
      // primaryColor: BodaColors.primaryColor,
      scaffoldBackgroundColor: const Color.fromARGB(255, 27, 36, 45),
      fontFamily: 'Montserrat',

      textTheme: TextTheme(
        bodyText1: GoogleFonts.montserrat(
          fontSize: 12,
          color: Colors.white,
        ),
        bodyText2: GoogleFonts.montserrat(
          fontSize: 14,
          color: Colors.white,
        ),
        headline3: GoogleFonts.montserrat(
          fontSize: 24,
          color: Colors.white,
        ),
        headline4: GoogleFonts.montserrat(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
        headline5: GoogleFonts.montserrat(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
        headline6: GoogleFonts.montserrat(
          fontSize: 30,
          color: Colors.white,
        ),
        caption: GoogleFonts.montserrat(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),

      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.black54),
      // radioTheme: RadioThemeData(
      //   fillColor: MaterialStateColor.resolveWith((states) => BodaColors.grey),
      // ),
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        // buttonColor: BodaColors.primaryColor,
      ),
    );
  }
}
