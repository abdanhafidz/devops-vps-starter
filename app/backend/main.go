package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

type Response struct {
	Message   string `json:"message"`
	Timestamp string `json:"timestamp"`
	Hostname  string `json:"hostname"`
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	secretKey := os.Getenv("SECRET_KEY")
	secretKeyFile := os.Getenv("SECRET_KEY_FILE")

	if secretKeyFile != "" {
		content, err := os.ReadFile(secretKeyFile)
		if err == nil {
			secretKey = string(content)
		} else {
			fmt.Printf("⚠️ Could not read secret file: %v\n", err)
		}
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()
		resp := Response{
			Message:   "Hello from Quzuu Backend!",
			Timestamp: time.Now().Format(time.RFC3339),
			Hostname:  hostname,
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	fmt.Printf("🚀 Server starting on port %s...\n", port)
	if secretKey != "" {
		fmt.Println("🔒 Secret key loaded")
	}
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
