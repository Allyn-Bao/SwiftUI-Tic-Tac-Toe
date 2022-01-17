//
//  ViewModel.swift
//  SwiftUITut-TicTacToe
//
//  Created by Allyn Bao on 2022-01-16.
//

import SwiftUI

final class ViewModel : ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @Published var isHumansTurn = true
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    @Published var gameEnds : Bool = false
    @Published var gameResult : GameResult = .incomplete
    @Published var message : String = " "
    
    func registerMove(boardIndex: Int) {
        if isAvaliable(boardIndex: boardIndex) {
            self.moves[boardIndex] = Move(player : isHumansTurn ? .human : .computer, boardIndex: boardIndex)
            isHumansTurn.toggle()
            
            ckeckGameResult()
            }
        }
    
    func humanMove(boardIndex: Int) {
        if isHumansTurn && !gameEnds {
            registerMove(boardIndex: boardIndex)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.computerMove()
            }
        }
    }
    
    func computerMove() {
        if !gameEnds {
            registerMove(boardIndex: determineComputerMoveBoardIndex())
        }
    }
    
    func determineComputerMoveBoardIndex() -> Int {
        var movePosition = Int.random(in: 0..<9)
        while !isAvaliable(boardIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func isAvaliable(boardIndex: Int) -> Bool {
        return moves[boardIndex] == nil
    }
    
    func allPositionsTaken() -> Bool {
        return moves.count == moves.compactMap { $0 }.count
    }
    
    func checkWin(for player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]]
        // compact Map : remove nil's
        // filter {} keeps this player's move only
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of:playerPositions) { return true }
        return false
    }
    
    func ckeckGameResult() {
        if checkWin(for: .human) {
            // human win
            gameEnds.toggle()
            gameResult = .win
            message = "You Won!"
            
        } else if checkWin(for: .computer) {
            // human lose
            gameEnds.toggle()
            gameResult = .lose
            message = "You Lost :("
            
        } else if allPositionsTaken() {
            // draw
            gameEnds.toggle()
            gameResult = .draw
            message = "Its a Draw."
        }
    }
    
    func reset() {
        isHumansTurn = true
        moves = Array(repeating: nil, count: 9)
        gameEnds = false
        gameResult = .incomplete
        message = " "
    }
}

enum Player {
    case human, computer
}

enum GameResult {
    case win, lose, draw, incomplete
}

struct Move {
    let player : Player
    let boardIndex : Int
    var indicator : String {
        return (player == .human) ? "xmark" : "circle"
    }
    
}
