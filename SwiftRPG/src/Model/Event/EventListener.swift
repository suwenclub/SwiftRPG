//
//  EventListener.swift
//  SwiftRPG
//
//  Created by 兎澤佑 on 2015/09/04.
//  Copyright © 2015年 兎澤佑. All rights reserved.
//

import Foundation
import SwiftyJSON
import SpriteKit
import PromiseKit

enum EventListenerError: Error {
    case illegalArguementFormat(String)
    case illegalParamFormat([String])
    case invalidParam(String)
}

enum TriggerType {
    case touch
    case immediate
    case button
}

protocol GameSceneProtocol {
    init(size: CGSize, playerCoordiante: TileCoordinate, playerDirection: DIRECTION)
    var playerInitialCoordinate: TileCoordinate? { get }
    var playerInitialDirection:  DIRECTION?      { get }
    
    var actionButton:      SKSpriteNode { get set }
    var menuButton:        SKSpriteNode { get set }
    var eventDialog:       SKSpriteNode { get set }
    var actionButtonLabel: SKLabelNode  { get set }
    var menuButtonLabel:   SKLabelNode  { get set }
    var eventDialogLabel:  SKLabelNode  { get set }
    var map:               Map?         { get set }
    var textBox:           Dialog!      { get set }

    func movePlayer(_ actions: [SKAction], departure: TileCoordinate, destination: TileCoordinate, screenAction: SKAction, invoker: EventListener)
        -> Promise<Void>
    func moveObject(_ name: String, actions: [SKAction], departure: TileCoordinate, destination: TileCoordinate, invoker: EventListener)
        -> Promise<Void>
    func hideAllButtons()     -> Promise<Void>
    func showDefaultButtons() -> Promise<Void>
    func showEventDialog()    -> Promise<Void>

    func stopBehaviors()
    func startBehaviors()
    func enableWalking()
    func disableWalking()
    func removeAllEvetListenrs()
    
    func enableTouchEvents()
    func disableTouchEvents()

    func transitionTo(_ newScene: GameScene.Type, playerCoordinate: TileCoordinate, playerDirection: DIRECTION) -> Promise<Void>
}

typealias EventMethod = (_ sender: GameSceneProtocol?, _ args: JSON?) throws -> Promise<Void>
protocol EventHandler: class {
    var invoke:        EventMethod?  { get set }
    var rollback:      EventMethod?  { get set }
    var triggerType:   TriggerType   { get }
}

typealias ListenerChain = [(listener: EventListener.Type, params: JSON?)]
protocol EventListener: EventHandler {
    var id:            UInt64!                 { get set }
    var delegate:      NotifiableFromListener? { get set }
    var listeners:     ListenerChain?          { get }
    var isExecuting:   Bool                    { get set }
    var isBehavior:    Bool                    { get set }
    var eventObjectId: MapObjectId?            { get set }

    func chain(listeners: ListenerChain)
    init(params: JSON?, chainListeners: ListenerChain?) throws
}
