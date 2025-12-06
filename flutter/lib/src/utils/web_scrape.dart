import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

void main() async {
  const String url = 'https://encycolorpedia.com/named';
  try {
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Document document = parse(response.body);
      final Element? colorTable = document.querySelector('table.color-table');

      if (colorTable != null) {
        final List<Element> colorRows = colorTable.querySelectorAll('tr');

        for (int i = 1; i < colorRows.length; i++) {
          final Element row = colorRows[i];
          final Element? hexIdElement = row.querySelector('td:nth-child(2)');
          final Element? nameElement = row.querySelector('td:nth-child(3)');

          if (hexIdElement != null && nameElement != null) {
            final String hexId = hexIdElement.text.trim();
            final String name = nameElement.text.trim();

            print('Name: $name, Hex ID: $hexId');
          } else {
            print('Failed to extract hex ID or name');
          }
        }
      } else {
        print('Color table not found');
      }
    } else {
      print('Failed to load page. Status code: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    print('HTTP client exception: $e');
  } on Exception catch (e) {
    print('General exception: $e');
  }
}
