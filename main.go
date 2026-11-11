package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"runtime"
	"time"
)

type HealthStatus struct {
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
	Uptime    string    `json:"uptime"`
	GoVersion string    `json:"go_version"`
	OSArch    string    `json:"os_arch"`
}

var startTime = time.Now()

func healthHandler(w http.ResponseWriter, r *http.Request) {

	// Create a HealthStatus response with relevant information
	response := HealthStatus{
		Status:    "UP",
		Timestamp: time.Now(),
		Uptime:    time.Since(startTime).String(),
		GoVersion: runtime.Version(),
		OSArch:    fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH),
	}

	// Set the response header to indicate JSON content
	w.Header().Set("Content-Type", "application/json")

	// Encode the response as JSON and write it to the response writer
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
	}
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Default port if not specified
	}

	http.HandleFunc("/health", healthHandler)

	// Start the HTTP server and listen on the specified port
	fmt.Printf("Starting server on port %s...\n", port)

	// Creamos el servidor HTTP configurando timeouts estrictos para evitar ataques de denegación de servicio (DoS)
	server := &http.Server{
		Addr:         ":" + port,
		Handler:      nil, // Use the default HTTP mux
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	if err := server.ListenAndServe(); err != nil {
		fmt.Printf("Failed to start server: %v\n", err)
		os.Exit(1)
	}
}
