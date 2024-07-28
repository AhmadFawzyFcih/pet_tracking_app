class PetServices::Index < PetServices::Base
    def call
        pets = filter(Pet.all)
        count = pets.length
        pets = pets.paginate(page: @page, per_page: @pagesize)

        [response(pets, {count: count}), 200]
    end
end