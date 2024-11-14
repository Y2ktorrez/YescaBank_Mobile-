import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yescabank/models/account_activity.dart';

class AccountCharts extends StatefulWidget {
  final List<AccountActivity> activityList;

  const AccountCharts({super.key, required this.activityList});

  @override
  _AccountChartsState createState() => _AccountChartsState();
}

class _AccountChartsState extends State<AccountCharts> {
  // Lista de opciones de gráficos disponibles
  final List<String> _chartOptions = [
    'Gráfico de Línea',
    'Gráfico de Barras',
    'Gráfico de Pastel',
    'Gráfico de Área',
    'Gráfico de Puntos'
  ];

  // Variable que almacena la opción de gráfico seleccionada
  String _selectedChart = 'Gráfico de Línea';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown para seleccionar el tipo de gráfico
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selecciona un gráfico: ',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                value: _selectedChart,
                items: _chartOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedChart = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Muestra el gráfico seleccionado
        Expanded(child: _buildSelectedChart()),
      ],
    );
  }

  // Método que construye el gráfico basado en la opción seleccionada
  Widget _buildSelectedChart() {
    switch (_selectedChart) {
      case 'Gráfico de Línea':
        return _buildLineChart(); // Llama al método que construye el gráfico de línea
      case 'Gráfico de Barras':
        return _buildBarChart(); // Llama al método que construye el gráfico de barras
      case 'Gráfico de Pastel':
        return _buildPieChart(); // Llama al método que construye el gráfico de pastel
      case 'Gráfico de Área':
        return _buildAreaChart(); // Llama al método que construye el gráfico de área
      case 'Gráfico de Puntos':
        return _buildScatterChart(); // Llama al método que construye el gráfico de puntos
      default:
        return _buildLineChart();
    }
  }

  // Método para crear un gráfico de línea
  Widget _buildLineChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart( 
        LineChartData(
          // Define el rango del eje X basado en la cantidad de datos
          minX: 0,
          maxX: widget.activityList.length.toDouble(),
          // Define el rango del eje Y basado en el balance mínimo y máximo
          minY: widget.activityList.map((e) => e.balance).reduce((a, b) => a < b ? a : b),
          maxY: widget.activityList.map((e) => e.balance).reduce((a, b) => a > b ? a : b),
          // Datos de las líneas en el gráfico
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(), // Genera los puntos para la línea
              isCurved: true, // Hace que la línea sea curva
              barWidth: 3, // Ancho de la línea
              color: Colors.blue, // Color de la línea
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.3), // Color debajo de la línea
              ),
              dotData: FlDotData(show: true), // Muestra puntos en cada dato
            ),
          ],
          borderData: FlBorderData(show: true), // Muestra borde alrededor del gráfico
          titlesData: _getTitlesData(), // Configura los títulos de los ejes
        ),
      ),
    );
  }

  // Método para crear un gráfico de barras
  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          barGroups: _generateBarGroups(), // Genera los grupos de barras
          borderData: FlBorderData(show: true),
          titlesData: _getTitlesData(),
        ),
      ),
    );
  }

  // Método para crear un gráfico de pastel
  Widget _buildPieChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          sections: _generatePieSections(), // Genera las secciones del gráfico de pastel
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  // Método para crear un gráfico de área (similar al gráfico de línea pero sombreado debajo)
  Widget _buildAreaChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(),
              isCurved: true,
              barWidth: 0,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
                ),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
          borderData: FlBorderData(show: true),
          titlesData: _getTitlesData(),
        ),
      ),
    );
  }

  // Método para crear un gráfico de puntos (scatter plot)
  Widget _buildScatterChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: _generateScatterSpots(), // Genera los puntos para el gráfico de dispersión
          borderData: FlBorderData(show: true),
          titlesData: _getTitlesData(),
        ),
      ),
    );
  }

  // Genera los puntos para el gráfico de línea y área
  List<FlSpot> _generateSpots() {
    double saldoAcumulado = 0;
    return widget.activityList.asMap().entries.map((entry) {
      saldoAcumulado += entry.value.balance; // Acumula el saldo
      return FlSpot(entry.key.toDouble(), saldoAcumulado); // Crea un punto en el gráfico
    }).toList();
  }

  // Genera los datos de barras para el gráfico de barras
  List<BarChartGroupData> _generateBarGroups() {
    double saldoAcumulado = 0;
    return widget.activityList.asMap().entries.map((entry) {
      saldoAcumulado += entry.value.balance;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: saldoAcumulado,
            color: Colors.lightGreen,
            width: 10,
          ),
        ],
      );
    }).toList();
  }

  // Genera las secciones del gráfico de pastel
  List<PieChartSectionData> _generatePieSections() {
    double saldoTotal = widget.activityList.fold(0, (sum, item) => sum + item.balance);
    return [
      PieChartSectionData(
        value: saldoTotal,
        color: Colors.lightBlue,
        radius: 60,
      ),
      PieChartSectionData(
        value: 2000 - saldoTotal,
        color: Colors.grey.shade200,
        radius: 40,
      ),
    ];
  }

  // Genera los puntos para el gráfico de dispersión
  List<ScatterSpot> _generateScatterSpots() {
    double saldoAcumulado = 0;
    return widget.activityList.asMap().entries.map((entry) {
      saldoAcumulado += entry.value.balance;
      return ScatterSpot(entry.key.toDouble(), saldoAcumulado);
    }).toList();
  }

  // Configura los títulos para los ejes X e Y
  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 32),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 32),
      ),
    );
  }
}
