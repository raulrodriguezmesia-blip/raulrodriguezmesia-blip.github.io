package com.raulrodriguez.portfolio.util;

import java.util.logging.*;

public class LogConfig {
    private static final Logger logger = Logger.getLogger(LogConfig.class.getName());

    public static void configurar() {
        try {
            // Obtener el root logger
            Logger rootLogger = LogManager.getLogManager().getLogger("");
            Handler[] handlers = rootLogger.getHandlers();

            // Configurar handlers existentes
            for (Handler handler : handlers) {
                handler.setLevel(Level.INFO);
                if (handler instanceof ConsoleHandler) {
                    // Usar formato simple en consola
                    handler.setFormatter(new SimpleFormatter());
                }
            }

            // Niveles por paquete
            Logger portfolioLogger = Logger.getLogger("com.raulrodriguez.portfolio");
            portfolioLogger.setLevel(Level.ALL);

            logger.info("Logging configurado correctamente");
        } catch (Exception e) {
            System.err.println("Error configurando logger: " + e.getMessage());
        }
    }
}
