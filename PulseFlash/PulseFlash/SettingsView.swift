import SwiftUI

struct SettingsView: View {
    @AppStorage("ipAddress") private var ipAddress: String = "127.0.0.1"
    @AppStorage("port") private var port: String = "3490"
    
    @State private var tempIP: String = ""
    @State private var tempPort: String = ""
    @State private var testResult: String? = nil
    @State private var isTesting = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.03, green: 0.05, blue: 0.1),
                    Color(red: 0.0, green: 0.1, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.1))
                            .frame(width: 140, height: 140)
                            .scaleEffect(1.1)
                            .blur(radius: 4)
                        
                        Circle()
                            .strokeBorder(Color.cyan.opacity(0.4), lineWidth: 4)
                            .frame(width: 120, height: 120)
                            .shadow(color: .cyan, radius: 10)
                        
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.cyan)
                    }
                    .padding(.top)
                    
                    Group {
                        // About
                        NavigationLink(destination: AboutView()) {
                            SettingsButton(icon: "info.circle.fill", text: "About PulseNerd")
                        }

                        // Other Apps
                        NavigationLink(destination: OurAppsView()) {
                            SettingsButton(icon: "apps.iphone", text: "Our Other Apps")
                        }

                        // Privacy Policy (externer Link)
                        Button(action: {
                            if let url = URL(string: "https://pulseview.nebuliton.de/pulseflash/flash_legal.html") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            SettingsButton(icon: "lock.shield.fill", text: "Privacy Policy")
                        }

                        // InfoView ("How to use this app safely")
                        NavigationLink(destination: InfoView()) {
                            SettingsButton(icon: "lightbulb.fill", text: "Usage Tips")
                        }
                    }
                    .padding(.horizontal)
                    
                    Group {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Connection Settings")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            
                            // IP TextField – volle Fläche klickbar
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.05))
                                
                                TextField("IP Address or Hostname", text: $tempIP)
                                    .keyboardType(.URL)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .frame(height: 48)
                            
                            // Port TextField – volle Fläche klickbar
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.05))
                                
                                TextField("Port", text: $tempPort)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .frame(height: 48)
                            
                            // Save Button
                            Button(action: saveAndTest) {
                                if isTesting {
                                    ProgressView()
                                } else {
                                    Text("Save & Test Connection")
                                        .bold()
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.cyan.opacity(0.2))
                                        .foregroundColor(.cyan)
                                        .cornerRadius(10)
                                }
                            }
                            
                            // Testergebnis
                            if let result = testResult {
                                Text(result)
                                    .foregroundColor(result.contains("Success") ? .green : .red)
                                    .font(.footnote)
                                    .padding(.top, 4)
                            }
                            
                            // Anleitung
                            Text("""
                            To enable the connection:
                            
                            1. Open the WhatPulse client on your computer.
                            2. Go to the Settings menu and select “Client API” in the sidebar.
                            3. Check the box “Enable Client API”.
                            4. (Optional) Change the port under “Listen on Port”.
                            5. Enter your phone or tablet’s IP address in the “Allow Connections From” field — or leave it blank to allow all.
                            """)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 32)
                    
                    Text("""
                    in pulses we trust
                    
                    synced in silent harmony
                    
                    data glows within.
                    """)
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    
                    Spacer(minLength: 60)
                }
                .padding(.top, 32)
                .onAppear {
                    tempIP = ipAddress
                    tempPort = port
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveAndTest() {
        ipAddress = tempIP
        port = tempPort
        isTesting = true
        testResult = nil
        
        guard let url = URL(string: "http://\(tempIP):\(tempPort)/") else {
            testResult = "Invalid URL"
            isTesting = false
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { _, response, error in
            DispatchQueue.main.async {
                isTesting = false
                if let error = error {
                    testResult = "Connection failed: \(error.localizedDescription)"
                } else if let http = response as? HTTPURLResponse {
                    testResult = http.statusCode == 200 ? "✅ Success!" : "⚠️ Status code: \(http.statusCode)"
                } else {
                    testResult = "Unknown response."
                }
            }
        }
        task.resume()
    }
}
    

struct SettingsButton: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.cyan)
            Text(text)
                .foregroundColor(.cyan)
                .bold()
            Spacer()
        }
        .padding()
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(12)
    }
}
