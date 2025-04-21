//
//  RawgAPI.swift
//  GameHive
//
//  Created by Darren Deng on 4/18/25.
//

import Foundation

class rawgViewModel: ObservableObject {
    @Published var trendingGames: [RAWGGame] = []
    @Published var upcomingGames: [RAWGGame] = []
    @Published var topRatedGames: [RAWGGame] = []
    private let apiKey = "8e45cb116d2944179df64c6625ccf674"
    private let baseURL = "https://api.rawg.io/api"
    
    init() { }
    
    func getTrendingGames() {
        guard let url = URL(string: "\(baseURL)/games?key=\(apiKey)&ordering=-rating&page_size=20") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from server")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let rawgResponse = try JSONDecoder().decode(RAWGResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.trendingGames = rawgResponse.results
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
