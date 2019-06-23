
import Foundation



// MARK: - Helper functions


func makeDummyOrdersStore() -> OrdersStore {

    let url = Bundle.main.url(forResource: "orders", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let response: APIResponse<[Order]> = data.decode()
    
    let store = OrdersStore()
    store.orders = response.data
    return store
}


func makeDummyColorsStore() -> ColorsStore {
    
    let url = Bundle.main.url(forResource: "colors", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let response: APIResponse<[BrickLinkColor]> = data.decode()
    
    let store = ColorsStore()
    store.colors = response.data
    return store
}


func makeDummyInventoriesStore() -> InventoriesStore {
    
    let url = Bundle.main.url(forResource: "inventories", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let response: APIResponse<[Inventory]> = data.decode()
    
    let store = InventoriesStore()
    store.inventories = response.data
    return store
}



// MARK: - Objects

let dummyOrdersStore = makeDummyOrdersStore()
let dummyColorsStore = makeDummyColorsStore()
let dummyInventoriesStore = makeDummyInventoriesStore()
