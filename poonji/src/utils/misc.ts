import {faker} from '@faker-js/faker';

const generate_user = () => {
    return `${faker.word.adjective()}_${faker.word.noun()}`;
}


export {generate_user};