#include <iostream>
#include <string>
#include <cctype>
#include <limits>

//===================================================================
// CONSTANTES DE DISEÑO (evitan números mágicos)
//===================================================================
const int PISOS = 4;
const int PUESTOS = 6;
const int HORA_APERTURA = 8;   // 8:00 AM
const int HORA_CIERRE = 18;    // 6:00 PM (18:00)
const int TARIFA_BASE = 250;   // primeras 5 horas o fracción
const int TARIFA_HORA_EXTRA = 500; // cada hora completa después de 5h
const int TARIFA_CUARTO = 200; // cada bloque de 15 min (o fracción) después de 5h
const int TARIFA_PERNOCTA = 1000; // tarifa plana si pernocta

//===================================================================
// VARIABLES GLOBALES (estado del sistema)
//===================================================================
std::string placa[PISOS][PUESTOS];           // placa del vehículo o "LIBRE"
int horaEntrada[PISOS][PUESTOS];             // hora de entrada (0-23)
int minEntrada[PISOS][PUESTOS];              // minuto de entrada (0-59)
bool pernocta[PISOS][PUESTOS];               // bandera de pernocta

// Métricas del día
int totalRevenue = 0;
int totalVehiculos = 0;
std::string placaMaxStay = "";
std::string placaMinStay = "";
int maxStayMin = -1;
int minStayMin = std::numeric_limits<int>::max();

//===================================================================
// FUNCIÓN DE LECTURA SEGURA DE ENTEROS
//===================================================================
int leerEnteroSeguro(const std::string& mensaje, int minVal, int maxVal) {
    int valor;
    while (true) {
        std::cout << mensaje;
        if (std::cin >> valor) {
            if (valor >= minVal && valor <= maxVal) {
                // entrada válida
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                return valor;
            } else {
                std::cout << "Valor fuera de rango [" << minVal << "-" << maxVal << "]. Intente de nuevo.\n";
            }
        } else {
            // entrada no numérica
            std::cout << "Entrada no válida. Por favor ingrese un número entero.\n";
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        }
    }
}

//===================================================================
// FUNCIÓN PARA CONVERTIR UNA CADENA A MAYÚSCULAS
//===================================================================
void aMayusculas(std::string& s) {
    for (char& c : s) {
        c = static_cast<char>(std::toupper(static_cast<unsigned char>(c)));
    }
}

//===================================================================
// BUSCAR UNA PLACA ACTIVA (devuelve true si la encuentra y deja i,j)
//===================================================================
bool buscarPlaca(const std::string& p, int& piso, int& puesto) {
    for (int i = 0; i < PISOS; ++i) {
        for (int j = 0; j < PUESTOS; ++j) {
            if (placa[i][j] == p && placa[i][j] != "LIBRE") {
                piso = i;
                puesto = j;
                return true;
            }
        }
    }
    return false;
}

//===================================================================
// CALCULAR TARIFA SEGÚN MINUTOS TOTALES (misma jornada)
//===================================================================
int calcularTarifa(int minutosTotales) {
    int costo = 0;
    if (minutosTotales <= 5 * 60) { // primeras 5 horas
        // cada hora o fracción cuenta como hora completa
        int horas = (minutosTotales + 59) / 60; // redondeo hacia arriba
        costo = horas * TARIFA_BASE;
    } else {
        // primeras 5 horas
        costo = 5 * TARIFA_BASE;
        int minutosExtra = minutosTotales - 5 * 60;
        // horas completas extra
        int horasExtra = minutosExtra / 60;
        costo += horasExtra * TARIFA_HORA_EXTRA;
        // minutos restantes (fracciones de hora)
        int minutosRest = minutosExtra % 60;
        if (minutosRest > 0) {
            // cada bloque de 15 min o fracción cuenta como 200
            int bloques = (minutosRest + 14) / 15; // techo
            costo += bloques * TARIFA_CUARTO;
        }
    }
    return costo;
}

//===================================================================
// REGISTRAR ENTRADA DE VEHÍCULO
//===================================================================
void registrarEntrada() {
    std::string p;
    std::cout << "Ingrese la placa del vehículo: ";
    std::cin >> p;
    aMayusculas(p);

    // verificar duplicada activa
    int tmpI, tmpJ;
    if (buscarPlaca(p, tmpI, tmpJ)) {
        std::cout << "Error: La placa " << p << " ya está registrada en el estacionamiento.\n";
        return;
    }

    int piso = leerEnteroSeguro("Ingrese piso (1-4): ", 1, PISOS) - 1;
    int puesto = leerEnteroSeguro("Ingrese puesto (1-6): ", 1, PUESTOS) - 1;

    if (placa[piso][puesto] != "LIBRE") {
        std::cout << "Error: El puesto seleccionado está ocupado.\n";
        return;
    }

    int hora = leerEnteroSeguro("Ingrese hora de entrada (8-17): ", HORA_APERTURA, HORA_CIERRE - 1);
    int minuto = leerEnteroSeguro("Ingrese minuto de entrada (0-59): ", 0, 59);

    // almacenar datos
    placa[piso][puesto] = p;
    horaEntrada[piso][puesto] = hora;
    minEntrada[piso][puesto] = minuto;
    pernocta[piso][puesto] = false;

    std::cout << "Entrada registrada correctamente para placa " << p << " en piso " << (piso + 1)
              << ", puesto " << (puesto + 1) << " a las " << hora << ":" << minuto << ".\n";
}

//===================================================================
// REGISTRAR SALIDA DE VEHÍCULO
//===================================================================
void registrarSalida() {
    std::string p;
    std::cout << "Ingrese la placa del vehículo que sale: ";
    std::cin >> p;
    aMayusculas(p);

    int piso, puesto;
    if (!buscarPlaca(p, piso, puesto)) {
        std::cout << "Error: Placa no encontrada o vehículo no está estacionado.\n";
        return;
    }

    // preguntar si pernoctó
    char resp;
    std::cout << "¿El vehículo pernoctó? (s/n): ";
    std::cin >> resp;
    resp = static_cast<char>(std::tolower(static_cast<unsigned char>(resp)));
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    int costo = 0;
    int minutosStay = 0;

    if (resp == 's') {
        costo = TARIFA_PERNOCTA;
        std::cout << "Tarifa pernocta aplicada: " << costo << " bolívares.\n";
    } else {
        int horaSalida = leerEnteroSeguro("Ingrese hora de salida (8-17): ", HORA_APERTURA, HORA_CIERRE - 1);
        int minSalida = leerEnteroSeguro("Ingrese minuto de salida (0-59): ", 0, 59);

        int entradaMin = horaEntrada[piso][puesto] * 60 + minEntrada[piso][puesto];
        int salidaMin = horaSalida * 60 + minSalida;

        if (salidaMin < entradaMin) {
            std::cout << "Error: La hora de salida debe ser posterior o igual a la hora de entrada.\n";
            return;
        }

        minutosStay = salidaMin - entradaMin;
        costo = calcularTarifa(minutosStay);
        std::cout << "Duración: " << minutosStay << " minutos. Tarifa calculada: " << costo << " bolívares.\n";

        // actualizar estadísticas de permanencia (solo para salidas del mismo día)
        if (minutosStay > maxStayMin) {
            maxStayMin = minutosStay;
            placaMaxStay = p;
        }
        if (minutosStay < minStayMin) {
            minStayMin = minutosStay;
            placaMinStay = p;
        }
    }

    // acumular revenue y contar vehículo
    totalRevenue += costo;
    ++totalVehiculos;

    // liberar puesto
    placa[piso][puesto] = "LIBRE";
    horaEntrada[piso][puesto] = 0;
    minEntrada[piso][puesto] = 0;
    pernocta[piso][puesto] = false;

    std::cout << "Salida registrada. Puesto liberado.\n";
}

//===================================================================
// MOSTRAR MAPA DE OCUPACIÓN
//===================================================================
void mostrarMapa() {
    std::cout << "\nMapa de ocupación del estacionamiento EL AMIGO:\n";
    std::cout << "   Puesto:  1     2     3     4     5     6\n";
    for (int i = 0; i < PISOS; ++i) {
        std::cout << "Piso " << (i + 1) << ": ";
        for (int j = 0; j < PUESTOS; ++j) {
            if (placa[i][j] == "LIBRE") {
                std::cout << "[LIBRE] ";
            } else {
                std::cout << '[' << placa[i][j] << "] ";
            }
        }
        std::cout << '\n';
    }
    std::cout << std::endl;
}

//===================================================================
// GENERAR REPORTE FINAL DE CAJA
//===================================================================
void generarReporteFinal() {
    std::cout << "\n=== REPORTE FINAL DE CAJA ===\n";
    std::cout << "Total vehículos atendidos hoy: " << totalVehiculos << "\n";
    std::cout << "Ingresos totales: " << totalRevenue << " bolívares\n";

    // vehículos restantes
    int restantes = 0;
    std::cout << "\nVehículos restantes en el estacionamiento:\n";
    for (int i = 0; i < PISOS; ++i) {
        for (int j = 0; j < PUESTOS; ++j) {
            if (placa[i][j] != "LIBRE") {
                ++restantes;
                std::cout << " - Placa: " << placa[i][j]
                          << " | Piso: " << (i + 1)
                          << " | Puesto: " << (j + 1) << '\n';
            }
        }
    }
    if (restantes == 0) {
        std::cout << " Ninguno.\n";
    }

    // estadísticas de permanencia (solo si hubo al menos una salida del mismo día)
    if (totalVehiculos > 0 && maxStayMin != -1) {
        std::cout << "\nAnálisis estadístico de permanencia (misma jornada):\n";
        std::cout << "  Mayor tiempo de permanencia: " << placaMaxStay
                  << " con " << maxStayMin << " minutos.\n";
        std::cout << "  Menor tiempo de permanencia: " << placaMinStay
                  << " con " << minStayMin << " minutos.\n";
    } else {
        std::cout << "\nNo hay datos de permanencia para el día.\n";
    }
    std::cout << "==============================\n\n";
}

//===================================================================
// FUNCIÓN PRINCIPAL
//===================================================================
int main() {
    // inicializar todos los puestos como LIBRE
    for (int i = 0; i < PISOS; ++i) {
        for (int j = 0; j < PUESTOS; ++j) {
            placa[i][j] = "LIBRE";
            horaEntrada[i][j] = 0;
            minEntrada[i][j] = 0;
            pernocta[i][j] = false;
        }
    }

    int opcion;
    do {
        std::cout << "\n=== ESTACIONAMIENTO EL AMIGO ===\n";
        std::cout << "1. Registrar entrada\n";
        std::cout << "2. Registrar salida\n";
        std::cout << "3. Mostrar mapa de ocupación\n";
        std::cout << "4. Generar reporte final y salir\n";
        std::cout << "Seleccione una opción: ";
        opcion = leerEnteroSeguro("", 1, 4);

        switch (opcion) {
            case 1:
                registrarEntrada();
                break;
            case 2:
                registrarSalida();
                break;
            case 3:
                mostrarMapa();
                break;
            case 4:
                generarReporteFinal();
                std::cout << "Sistema finalizado.\n";
                break;
        }
    } while (opcion != 4);

    return 0;
}