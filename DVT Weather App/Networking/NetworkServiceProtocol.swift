//
//  NetworkServiceProtocol.swift
//  DVT Weather App
//
//  Created by GICHUKI on 12/01/2025.
//

import Foundation

protocol NetworkServiceProtocol{
    func requestData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
