
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



// MARK: - Objects

let dummyOrdersStore = makeDummyOrdersStore()
