//
//  RawgAPI.swift
//  GameHive
//
//  Created by Darren Deng on 4/18/25.
//
//  This is the rawg view model
//  Calls the rawgAPI web service
//
//  Very helpful guide used for completion handlers:
//  https://medium.com/@ankuriosdev/mastering-escaping-in-swift-when-and-why-your-completion-handlers-need-to-escape-4223aa364de3
//
//  Another helpful guide (dispatch queues):
//  https://medium.com/@vinodh_36508/mastering-dispatch-queues-in-swift-understanding-implementation-and-limitations-4ed37916fe8a

import Foundation

class RawgViewModel: ObservableObject {
    // Hold category of games
    // Max of 25
    @Published var topRatedGames: [RawgGame] = []
    @Published var upcomingGames: [RawgGame] = []
    @Published var anticipatedGames: [RawgGame] = []
    
    // Hold extended version of the categories
    // Max of 100
    @Published var extendedTopRatedGames: [RawgGame] = []
    @Published var extendedUpcomingGames: [RawgGame] = []
    @Published var extendedAnticipatedGames: [RawgGame] = []
    
    // For loading
    @Published var isLoadingTopRated: Bool = false
    @Published var isLoadingUpcoming: Bool = false
    @Published var isLoadingAnticipated: Bool = false
    @Published var isLoadingGameDetails: Bool = false
    @Published var selectedGameDetail: RawgGameDetail?
    
    private let apiKey = "8e45cb116d2944179df64c6625ccf674"
    private let baseURL = "https://api.rawg.io/api"
    
    init() { }
    
    // Function to get top rated games
    // Is asynchronous and relies on the completion handler
    // Calls fetchGames
    // Sets the category of games
    func fetchTopRatedGames(quantity: Int = 25, completion: @escaping ([RawgGame]) -> Void = {_ in}) {
        isLoadingTopRated = true
        fetchGames(endpoint: "/games", params: "&ordering=-metacritic&page_size=\(quantity)") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingTopRated = false
                switch result {
                case .success(let games):
                    let filteredGames = games.filter { game in
                        return game.backgroundImage != nil && !game.backgroundImage!.isEmpty
                    }
                    
                    // Another really hacky-ish method
                    // Depending on count of games, set main category or extended category
                    if quantity <= 25 {
                        self?.topRatedGames = filteredGames
                    } else {
                        self?.extendedTopRatedGames = filteredGames
                    }
                    
                    completion(filteredGames)
                case .failure(let error):
                    print("Error fetching top rated games: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    // Function to get most anticipated games
    // Is asynchronous and relies on the completion handler
    // Calls fetchGames
    // Sets the category of games
    func fetchAnticipatedGames(quantity: Int = 25, completion: @escaping ([RawgGame]) -> Void = {_ in}) {
        isLoadingAnticipated = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        // Up to 2026, can change if want
        fetchGames(endpoint: "/games", params: "&dates=\(today),2026-12-31&ordering=-added&page_size=\(quantity)") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingAnticipated = false
                switch result {
                case .success(let games):
                    let filteredGames = games.filter { game in
                        return game.backgroundImage != nil && !game.backgroundImage!.isEmpty
                    }
                    
                    // Hacky method strikes again
                    if quantity <= 25 {
                        self?.anticipatedGames = filteredGames
                    } else {
                        self?.extendedAnticipatedGames = filteredGames
                    }
                    
                    completion(filteredGames)
                case .failure(let error):
                    print("Error fetching anticipated games: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    // Function to get upcoming games
    // Is asynchronous and relies on the completion handler
    // Calls fetchGames
    // Sets the category of games
    func fetchUpcomingGames(quantity: Int = 25, completion: @escaping ([RawgGame]) -> Void = {_ in}) {
        isLoadingUpcoming = true
        
        // Get thecurrent date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        // Up to 2026, can change it if want
        fetchGames(endpoint: "/games", params: "&ordering=released&dates=\(today),2026-12-31&page_size=\(quantity)") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingUpcoming = false
                switch result {
                case .success(let games):
                    let filteredGames = games.filter { game in
                        return game.backgroundImage != nil && !game.backgroundImage!.isEmpty
                    }
                    
                    // Hacky method again
                    if quantity <= 25 {
                        self?.upcomingGames = filteredGames
                    } else {
                        self?.extendedUpcomingGames = filteredGames
                    }
                    
                    completion(filteredGames)
                case .failure(let error):
                    print("Error fetching upcoming games: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    // The bread and butter of this class
    // Main function used to call the rawgAPI
    // Decodes the JSON response
    // Used for the /games endpoint mainly
    // (RawgGame)
    func fetchGames(endpoint: String, params: String, completion: @escaping (Result<[RawgGame], Error>) -> Void) {
        // Filters to keep this project appropriate for ASU (We had a lot of NSFW results)
        // ... like really .. so many NSFW results
        let nsfwFilters = params + "&exclude_additions=true&tags_exclude=sexual-content,nudity,mature&exclude_collection=true"
        guard let url = URL(string: "\(baseURL)\(endpoint)?key=\(apiKey)\(params)\(nsfwFilters)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: -2, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -3, userInfo: nil)))
                return
            }
            
            do {
                let rawgResponse = try JSONDecoder().decode(RawgResponse.self, from: data)
                let validGames = rawgResponse.results.filter { game in
                    if let backgroundImage = game.backgroundImage, !backgroundImage.isEmpty {
                        return true
                    }
                    return false
                }
                completion(.success(validGames))
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON: \(jsonString.prefix(200))")
                }
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Function that modifies the URI to search for a game
    // Uses fuzzy searching by default
    func searchGames(query: String, completion: @escaping (Result<[RawgGame], Error>) -> Void) {
        fetchGames(endpoint: "/games", params: "&search=\(query)") { result in
            completion(result)
        }
    }
    
    // Function to fetch the details of a game
    // Requires the game's id number from rawg
    // (RawgGameDetail)
    func fetchGameDetails(gameId: Int, completion: @escaping (Result<RawgGameDetail, Error>) -> Void) {
        isLoadingGameDetails = true
        
        // I didn't apply the NSFW filters here so BE CAREFUL SEARCHING
        // This is because I wanted to search for (socially acceptable) games like Call of Duty
        guard let url = URL(string: "\(baseURL)/games/\(gameId)?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoadingGameDetails = false
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "Invalid response", code: -2, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -3, userInfo: nil)))
                    return
                }
                
                do {
                    let gameDetail = try JSONDecoder().decode(RawgGameDetail.self, from: data)
                    self?.selectedGameDetail = gameDetail
                    completion(.success(gameDetail))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
